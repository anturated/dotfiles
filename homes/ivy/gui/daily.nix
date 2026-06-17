{
  pkgs,
  config,
  lib,
  ...
}:

{
  # these don't deserve separate modules probably
  ceirios.packages = lib.mkIf config.ceirios.profiles.graphical {
    inherit (pkgs)
      vivaldi
      telegram-desktop
      anytype
      libreoffice
      signal-desktop
      ;
  };
}
