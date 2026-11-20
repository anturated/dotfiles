{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib.modules) mkIf;
  inherit (config.ceirios.profiles) laptop;
in
{
  services = mkIf laptop.enable {
    tuned = {
      enable = true;

      # override profiles in case i don't like something
      profiles = {
        ceirios-powersave = {
          main = {
            summary = "We quiet";
            include = "powersave";
          };
        };

        # looks like laptop-battery-powersave just includes powersave.
        ceirios-powersave-bat = {
          main = {
            summary = "We squeeze that battery";
            include = "laptop-battery-powersave";
          };
        };

        ceirios-balanced = {
          main = {
            summary = "We chill";
            include = "balanced";
          };
        };

        ceirios-balanced-bat = {
          main = {
            summary = "We need more power";
            include = "balanced-battery";
          };
        };

        ceirios-performance = {
          main = {
            summary = "We game";
            include = "latency-performance";
          };

          cpu = {
            # idk why this isn't performance by default
            governor = "performance|schedutil";
          };

          # might be better for stutters
          vm = {
            dirty_bytes = "40%";
            dirty_background_bytes = "10%";
          };
        };
      };

      # make tuned impersonate ppd so we have nice integrations across shells
      ppdSettings = {
        main = {
          # note: these require acpid and upower.
          # ppd bridge enables upower but acpid is on me
          # (it's tied to laptop profile so we should be fine)
          # and sysfs_acpi_monitor is on by default now
          # (the nixos module stil doesn't allow tweaking it smh)

          # use -bat profiles from below when on battery.
          # doesn't swap automatically so we have to summon daemons below
          battery_detection = true;
        };

        # ppd -> tuned profile bridge
        # on ac:
        profiles = {
          power-saver = "ceirios-powersave";
          balanced = "ceirios-balanced";
          performance = "ceirios-performance";
        };

        # on battery:
        battery = {
          power-saver = "ceirios-powersave-bat";
          balanced = "ceirios-balanced-bat";
        };
      };
    };
  };

  # HACK: restart tuned-ppd on config change.
  # tuned-ppd doesn't restart on config change from a rebuild.
  # am i mad? yes. am i gonna report any of this? hell no.
  # remove this block if they ever fix it
  systemd.services.tuned-ppd = mkIf laptop.enable {
    restartTriggers = [ config.environment.etc."tuned/ppd.conf".source ];
  };

  # note: hardware switches to quiet mode silently for whatever reason,
  # so tuned has no idea it has to switch to power save,
  # so i have to do all that below.
  # i have no idea if this is a lenovo firmware bug or a global issue.
  # hope someone will discover and fix this without my input :)

  # check if platform profile and tuned profile mismatches every now and then and switch.
  # also handle ac plug/unplug and change profile because tuned couldn't care less
  systemd.services.ceirios-platform-profile-sync = mkIf laptop.enable {
    description = "fixes quiet profile switch; switches profile on ac plug/unplug. i'm sane and not crying.";

    wantedBy = [ "multi-user.target" ];
    wants = [ "tuned-ppd.service" ];
    after = [ "tuned-ppd.service" ];

    path = [
      pkgs.coreutils
      pkgs.systemd
    ];

    serviceConfig = {
      Restart = "always";
      RestartSec = 2;
    };

    script = ''
      fw=/sys/firmware/acpi/platform_profile
      ac=
      for s in /sys/class/power_supply/*; do
        if [ "$(cat "$s/type")" = Mains ]; then ac=$s/online; fi
      done
      ppd=(net.hadess.PowerProfiles /net/hadess/PowerProfiles net.hadess.PowerProfiles ActiveProfile)

      get_ppd() {
        busctl --system get-property "''${ppd[@]}" | cut -d'"' -f2;
      }

      set_ppd() {
        echo "setting $1 ($2)"
        busctl --system set-property "''${ppd[@]}" s "$1" || true
      }

      last_fw=$(cat $fw)
      last_ac=1
      if [ -n "$ac" ]; then last_ac=$(cat "$ac"); fi

      while sleep 1; do
        if [ -n "$ac" ]; then
          now_ac=$(cat "$ac")
          if [ "$now_ac" != "$last_ac" ]; then
            last_ac=$now_ac
            if [ "$now_ac" = 0 ]; then
              set_ppd power-saver unplugged
            elif [ "$(get_ppd)" != performance ]; then
              set_ppd balanced "plugged in"
            fi
            continue
          fi
        fi

        now_fw=$(cat $fw)
        if [ "$now_fw" = "$last_fw" ]; then continue; fi

        # tuned writes balanced while switching profiles for whatever mythical reason.
        # wait for it to write the actual thing
        sleep 0.5
        if [ "$(cat $fw)" != "$now_fw" ]; then continue; fi
        last_fw=$now_fw

        case $now_fw in
          low-power) want=power-saver ;;
          balanced | performance) want=$now_fw ;;
          *) continue ;;
        esac
        if [ "$(get_ppd)" != "$want" ]; then set_ppd "$want" "firmware is $now_fw"; fi
      done
    '';
  };
}
