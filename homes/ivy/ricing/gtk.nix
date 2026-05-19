{
  pkgs,
  config,
  lib,
  ...
}:

let
  schema = pkgs.gsettings-desktop-schemas;
in
{
  config = lib.mkIf config.ceirios.profiles.graphical {
    # gsettings for hot reload, requires dbus and dconf.
    ceirios.packages = { inherit (pkgs) glib; };

    # and apparently this, because it doesn't know what schemas is
    xdg.systemDirs.data = [ "${schema}/share/gsettings-schemas/${schema.name}" ];

    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };

    home = {
      pointerCursor = {
        gtk.enable = true;
        x11.enable = true;
        name = "volantes_cursors";
        package = pkgs.volantes-cursors;
        size = 24;
      };

      # gtk applications should use xdg specified settings
      sessionVariables.GTK_USE_PORTAL = "1";
    };

    gtk = {
      enable = true;

      font = {
        inherit (config.ceirios.style.fonts) name;
      };

      theme = {
        # this is the one that matugen works with
        name = "adw-gtk3-dark";
        package = pkgs.adw-gtk3;
      };

      iconTheme = {
        name = "Colloid-Grey-Nord-Dark";
        package = pkgs.colloid-icon-theme.override {
          colorVariants = [ "grey" ];
          schemeVariants = [ "nord" ];
        };
      };

      gtk4 = {
        theme = config.gtk.theme;

        extraConfig = {
          gtk-application-prefer-dark-theme = 1;
        };

        # this should get it to load matugen colors
        extraCss = ''
          @import 'colors.css';
        '';
      };

      gtk3 = {
        extraConfig = {
          gtk-application-prefer-dark-theme = 1;
        };

        extraCss = ''
          @import 'colors.css';
        '';
      };
    };

    xresources.properties = {
      "Xft.dpi" = 96;
      "Xft.antialias" = true;
      "Xft.hinting" = true;
      "Xft.autohint" = false;
      "Xft.hintstyle" = "hintslight";
      "Xft.lcdfilter" = "lcddefault";
      "Xft.rgba" = "rgb";
    };
  };
}
