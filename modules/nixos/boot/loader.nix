{ config, lib, ... }:

let
  inherit (lib.modules)
    mkForce
    mkDefault
    mkMerge
    mkIf
    ;
  inherit (lib.options) mkOption;
  inherit (lib.types) enum nullOr str;

  cfg = config.ceirios.boot;
in
{
  options.ceirios.boot = {
    loader = mkOption {
      type = enum [
        "systemd-boot"
        "grub"
        "none"
      ];
      default = "systemd-boot";
      description = "Your bootloader";
    };

    grub.device = mkOption {
      type = nullOr str;
      default = "nodev";
      description = "Device (the entire disk) where grub lives.";
      example = "/dev/sda";
    };
  };

  config = mkMerge [
    (mkIf (cfg.loader == "systemd-boot") {
      boot.loader.systemd-boot = {
        enable = mkDefault true;
      };
    })

    (mkIf (cfg.loader == "grub") {
      boot.loader.grub = {
        enable = mkDefault true;
        useOSProber = true;
        efiSupport = true;
        enableCryptodisk = mkDefault false;
        inherit (cfg.grub) device;
        theme = null;
        backgroundColor = null;
        splashImage = null;
      };
    })

    (mkIf (cfg.loader == "none") {
      boot.loader = {
        grub.enable = mkForce false;
        systemd-boot.enable = mkForce false;
      };
    })
  ];
}
