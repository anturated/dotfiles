{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib.modules) mkIf;
  inherit (config.ceirios.profiles) gaming;
in
{
  ceirios.packages = mkIf gaming.enable {
    # using stable here because openldap won't pass tests
    # inherit (pkgs) bottles;
  };
}
