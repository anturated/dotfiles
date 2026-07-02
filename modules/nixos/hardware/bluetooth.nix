{ lib, config, ... }:

let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
in
{
  options.ceirios.hardware.bluetooth = {
    enable = mkEnableOption "bluetooth support";
  };

  config = mkIf config.ceirios.hardware.bluetooth.enable {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;

      # might fix autostart
      disabledPlugins = [ "sap" ];

      settings = {
        General = {
          # Shows battery charge
          Experimental = true;
          # Faster connect, more power drain
          FastConnectable = true;
          # repair stuff
          JustWorksRepairing = "always";
          MultiProfile = "multiple";
        };

        AVRCP = {
          # should disable absolute volume
          VolumeWithoutTarget = false;
        };

        # Enable all controllers when they are found.
        Policy.AutoEnable = true;
      };
    };
  };
}
