import os
import pwd
import dbus
import dbus.service
import dbus.mainloop.glib
from gi.repository import GLib
import subprocess

# from pathlib import Path

# describes what the client wants active while it's registered
class KaleClient():
    def __init__(self, pid: int, hypr_sig: str, xdg_runtime: str, use_hypr: bool, use_power: bool):
        self.pid = pid
        self.hypr_sig = hypr_sig
        self.xdg_runtime = xdg_runtime
        self.use_hypr = use_hypr
        self.use_power = use_power


# the daemon
class KaleDaemon(dbus.service.Object):


    ### INIT ###


    def __init__(self):
        # track clients
        self.clients: list[KaleClient] = []

        # track optimized hypr sessions
        self.using_hypr_sigs: set[str] = set()

        # and their users
        self.hypr_xdgs: dict[str, str] = {}

        # track if we enabled performance profile
        self.using_power: bool = False

        # setup dbus stuff
        bus_name = dbus.service.BusName('com.anturated.kaled', bus=dbus.SystemBus())
        dbus.service.Object.__init__(self, bus_name, '/com/anturated/kaled')
        print("Kale Daemon started...")


    ### HELPERS ###


    # aint nobody typing all that
    def run_command(self, command: str):
        parts = command.split(" ")
        subprocess.run(parts)


    # hyprctl just won't work from root for some reason
    # so we just... pretend to be the user playing the game
    # this feels awful, might rework
    def run_hypr_command(self, command: list[str], sig: str, xdg: str):
        # get username
        uid = int(xdg.split('/')[-1])
        user = pwd.getpwuid(uid).pw_name

        # pretend to be username
        full_cmd = ["sudo", "-u", user, "env",
                    f"HYPRLAND_INSTANCE_SIGNATURE={sig}",
                    f"XDG_RUNTIME_DIR={xdg}"] + command

        # capture error output just in case
        result = subprocess.run(full_cmd, capture_output=True, text=True)
        if result.returncode != 0:
            print(f"[kale] Error running hyprctl: {result.stderr}")


    # disables a bunch of cosmetic stuff that might give us performance
    # AND enables the big direct_scanout
    def hypr_optimize(self, sig: str, xdg: str):
        self.run_hypr_command([
            "hyprctl", "eval", (
            "hl.config({"
            "    general = {"
            "        gaps_in = 0,"
            "        gaps_out = 0,"
            "    },"
            "    decoration = {"
            "        rounding = 0,"
            "        shadow = { enabled = false },"
            "        blur = { enabled = false },"
            "    },"
            "    animations = { enabled = false },"
            "})"
        )], sig, xdg)


    # resets the config because idk what was enabled
    def hypr_reset(self, sig: str, xdg: str):
        self.run_hypr_command(["hyprctl", "reload"], sig, xdg)


    ### UPDATER ###


    # enable/disable wanted stuff based on current client list
    def update_performance(self):
        # optimize hyprland session #

        # get registered sigs
        current_sigs = set(c.hypr_sig for c in self.clients)

        # add unregistered sigs that are still optimized
        all_sigs = current_sigs.union(self.using_hypr_sigs)

        # check all sessions
        for sig in all_sigs:
            # grab this for impersonation
            xdg_runtime = self.hypr_xdgs[sig]

            # is there a client that wants this session optimized
            wants_hypr = any(c.hypr_sig == sig and c.use_hypr for c in self.clients)

            # is the session optimized
            is_optimized = sig in self.using_hypr_sigs

            if wants_hypr and not is_optimized:
                print(f"[kale] Applying hypr optimizations for {sig}...")
                self.hypr_optimize(sig, xdg_runtime)
                self.using_hypr_sigs.add(sig)
            elif not wants_hypr and is_optimized:
                print(f"[kale] Resetting hypr optimizations for {sig}...")
                self.hypr_reset(sig, xdg_runtime)
                self.using_hypr_sigs.discard(sig)

        # optimize power profile #

        # is there a client that wants power
        need_power = any(c.use_power for c in self.clients)

        if need_power and not self.using_power:
            print("[kale] Applying power optimizations...")
            self.run_command("tuned-adm profile ceirios-performance")
            self.using_power = True
        elif not need_power and self.using_power:
            print("[kale] Resetting power optimizations...")
            self.run_command("tuned-adm profile ceirios-balanced")
            self.using_power = False

        # try tlpd
        # governor   = "performance" if need_power else "schedutil"
        # boost      = "1"           if need_power else "0"
        # profile    = "performance" if need_power else "balanced"
        #
        # # scaling
        # for path in Path("/sys/devices/system/cpu").glob("cpu*/cpufreq/scaling_governor"):
        #     path.write_text(governor)
        #
        # # boost
        # Path("/sys/devices/system/cpu/cpufreq/boost").write_text(boost)
        #
        # # profile
        # Path("/sys/firmware/acpi/platform_profile").write_text(profile)
        #
        # self.using_power = need_power

    ### API ###


    # register
    @dbus.service.method('com.anturated.kaled', in_signature='issbb', out_signature='s')
    def RegisterClient(self, pid: int, hypr_sig: str, xdg_runtime: str, use_hypr: bool, use_power: bool):
        # save all the info
        new_client = KaleClient(pid, hypr_sig, xdg_runtime, use_hypr, use_power)
        self.clients.append(new_client)

        # save xdg_runtime separately because we need it
        # to reset hypr config after the client is unregistered
        # not the best approach but i'm not redoing this right now.
        self.hypr_xdgs[hypr_sig] = xdg_runtime

        # apply whatever our clients want
        self.update_performance()
        return f"[kale] Registered {pid}"


    # unregister
    @dbus.service.method('com.anturated.kaled', in_signature='i', out_signature='s')
    def UnregisterClient(self, pid: int):
        # remove client
        self.clients = [c for c in self.clients if c.pid != pid]

        # adjust optimizations
        self.update_performance()
        return f"[kale] Unregistered {pid}"


### MAIN ###


dbus.mainloop.glib.DBusGMainLoop(set_as_default=True)
daemon = KaleDaemon()
loop = GLib.MainLoop()
loop.run()
