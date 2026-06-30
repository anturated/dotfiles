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

        # NOTE: looks like laptop-battery-powersave just includes powersave.
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

          # hope this helps my electricity bill
          cpu = {
            boost = 0;
          };
        };

        ceirios-balanced-bat = {
          main = {
            summary = "We need more power";
            include = "balanced-battery";
          };

          cpu = {
            boost = 0;
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
        # auto switching on laptops
        main = {
          # these require acpid

          # watch ac plug/unplug
          battery_detection = false; # INFO: broken, see ppdSettings.battery below

          # watch acpi stuff like hardware key profile switch (Fn+Q, Fn+L, etc.)
          # sysfs_acpi_monitor = true; # WARN: looks like it's not supported here yet :\
        };

        # ppd -> tuned profile bridge
        # on ac:
        profiles = {
          power-saver = "ceirios-powersave";
          balanced = "ceirios-balanced";
          performance = "ceirios-performance";
        };

        # on battery:
        # WARN: looks correct in the config but has no effect :\
        # defaults to balanced-power which shouldn't be too bad
        battery = {
          power-saver = "ceirios-powersave-bat";

          # might change to powersave if the laptop doesn't handle this too well
          balanced = "ceirios-balanced-bat";
        };
      };
    };

    # HACK: this should be handled by tuned.ppdSettings.main.sysfs_acpi_monitor
    udev.extraRules = ''
      ACTION=="change", SUBSYSTEM=="platform", \
        ATTR{/sys/firmware/acpi/platform_profile}=="low-power", \
        RUN+="${pkgs.tuned}/bin/tuned-adm profile ceirios-powersave-bat"

      ACTION=="change", SUBSYSTEM=="platform", \
        ATTR{/sys/firmware/acpi/platform_profile}=="balanced", \
        RUN+="${pkgs.tuned}/bin/tuned-adm profile ceirios-balanced"

      ACTION=="change", SUBSYSTEM=="platform", \
        ATTR{/sys/firmware/acpi/platform_profile}=="performance", \
        RUN+="${pkgs.tuned}/bin/tuned-adm profile ceirios-performance"

      ACTION=="change", SUBSYSTEM=="power_supply", \
        ATTR{type}=="Mains", ATTR{online}=="0", \
        RUN+="${pkgs.tuned}/bin/tuned-adm profile ceirios-powersave-bat"

      ACTION=="change", SUBSYSTEM=="power_supply", \
        ATTR{type}=="Mains", ATTR{online}=="1", \
        RUN+="${pkgs.tuned}/bin/tuned-adm profile ceirios-balanced"
    '';
  };
}
