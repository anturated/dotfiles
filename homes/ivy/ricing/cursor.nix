{ config, pkgs, ... }:

{
  home.pointerCursor = {
    inherit (config.ceirios.profiles.graphical) enable;

    gtk.enable = true;
    x11.enable = true;
    name = "volantes_cursors";
    package = pkgs.volantes-cursors;
    size = 24;
  };
}
