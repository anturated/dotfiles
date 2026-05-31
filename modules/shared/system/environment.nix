{ lib, config, ... }:

let
  inherit (config.ceirios.system) flakeDir;
in
{
  options.ceirios.system.flakeDir = lib.mkOption {
    type = lib.types.str;
    default = "";
    description = "Path to your local config";
  };

  config.environment.variables = {
    # let other programs know where the flake is.
    # useful for something like 'nh', not necessary with nixos-rebuild
    FLAKE = flakeDir;
    NH_FLAKE = flakeDir;

    # avoid RCE in pagers. the more you know.
    SYSTEMD_PAGERSECURE = "true";
  };
}
