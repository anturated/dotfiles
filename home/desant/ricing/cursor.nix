{ config, pkgs, ... }:

{
  home.pointerCursor = {
    inherit (config.ceirios.profiles.graphical) enable;

    gtk.enable = true;
    # i don't plan on using X and disabling this saves space so
    x11.enable = false;
    name = "volantes_cursors";
    package = pkgs.volantes-cursors;
    size = 24;
    dotIcons.enable = false; # removes ~/.icons
  };
}
