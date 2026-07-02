{ lib, config, ... }:

let
  inherit (lib.options) mkOption;
  inherit (lib.types) str;
  inherit (config.ceirios.system) flakeDir;
in
{
  options.ceirios.system.flakeDir = mkOption {
    type = str;
    default = "";
    description = "Path to your local config";
    example = "$HOME/dev/dotfiles";
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
