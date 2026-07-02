{
  pkgs,
  config,
  lib,
  ...
}:

let
  inherit (lib.modules) mkIf;
  inherit (config.ceirios.profiles) gaming;
in
{
  # we play celeste here
  ceirios.packages = mkIf gaming.enable {
    inherit (pkgs) olympus;
  };
}
