{
  pkgs,
  config,
  lib,
  ...
}:

let
  inherit (lib.modules) mkIf;
  inherit (config.ceirios.profiles) graphical;
in
{
  # these don't deserve separate modules probably
  ceirios.packages = mkIf graphical.enable {
    inherit (pkgs)
      vivaldi
      telegram-desktop
      anytype
      libreoffice
      signal-desktop
      ;
  };
}
