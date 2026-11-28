{ lib, config, ... }:

let
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.modules) mkIf;
  inherit (lib.types) nullOr bool;

  cfg = config.ceirios.hardware.bluetooth;
in
{
  options.ceirios.hardware.bluetooth = {
    enable = mkEnableOption "bluetooth support";
    powerOnBoot = mkOption {
      type = nullOr bool;
      default = null;
      description = "Enable bluetooth power on boot. null uses nixpkgs default.";
    };

  };

  config = mkIf cfg.enable {
    hardware.bluetooth = {
      enable = true;

      # as of 28-11-2026 defaults to true
      powerOnBoot = mkIf (cfg.powerOnBoot != null) cfg.powerOnBoot;

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
      };
    };
  };
}
