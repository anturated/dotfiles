{ lib, config, ... }:

let
  inherit (lib.attrsets) mapAttrs;
  inherit (lib.modules) mkIf mkForce;
in
{
  config = mkIf config.ceirios.profiles.headless {
    # print the URL instead
    environment.variables.BROWSER = "echo";

    # don't need fonts on a server
    fonts = mapAttrs (_: mkForce) {
      packages = [ ];
      fontDir.enable = false;
      fontconfig.enable = false;
    };

    # disable mounting external media
    services.udisks2.enable = mkForce false;

    xdg = mapAttrs (_: mkForce) {
      sounds.enable = false;
      mime.enable = false;
      menus.enable = false;
      icons.enable = false;
      autostart.enable = false;
    };

    # https://github.com/numtide/srvos/blob/main/nixos/server/default.nix
    systemd = {
      # continue trying to boot in the hopes we might regain access
      enableEmergencyMode = false;

      settings.Manager = {
        # systemd will ping the watchdog at half this interval
        # if the watchdog does not get pinged for this long it will reboot the system.
        RuntimeWatchdogSec = "20s";
        # max wait time on reboot before it's forced
        RebootWatchdogSec = "30s";
      };

      sleep.settings.Sleep = {
        AllowSuspend = false;
        AllowHibernation = false;
        AllowSuspendThenHibernate = false;
        AllowHybridSleep = false;
      };
    };

    # TODO: move this out of here, this isn't really "headless" stuff
    boot = {
      loader.grub = {
        useOSProber = mkForce false;
        efiSupport = mkForce false;
      };
    };
  };
}
