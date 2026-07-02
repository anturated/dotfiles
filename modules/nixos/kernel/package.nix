{
  lib,
  pkgs,
  config,
  ...
}:

let
  inherit (lib.modules) mkOverride;
  inherit (lib.options) mkOption;
  inherit (lib.types) raw;

  cfg = config.ceirios.system.kernel;
in
{
  options.ceirios.system.kernel = {
    packages = mkOption {
      type = raw;
      default = pkgs.linuxPackages_latest;
      defaultText = "pkgs.linuxPackages_latest";
      description = "Your kernel.";
    };
  };

  config = {
    # set to config default, allow explicit overrides
    # by the likes of nixos-hardware
    boot.kernelPackages = mkOverride 500 cfg.packages;
  };
}
