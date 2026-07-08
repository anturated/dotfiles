{
  pkgs,
  config,
  lib,
  ...
}:

let
  inherit (lib.modules) mkIf;
  inherit (config.ceirios.profiles) graphical;
  schema = pkgs.gsettings-desktop-schemas;
in
{
  config = mkIf graphical.enable {
    # gsettings for hot reload, requires dbus and dconf.
    ceirios.packages = { inherit (pkgs) glib; };

    # and apparently this, because it doesn't know what schemas is
    xdg.systemDirs.data = [ "${schema}/share/gsettings-schemas/${schema.name}" ];

    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };

    home.sessionVariables = {
      # gtk applications should use xdg specified settings
      GTK_USE_PORTAL = "1";
    };

    gtk = {
      enable = true;

      font = {
        name = "Geist";
        package = pkgs.geist-font;
      };

      theme = {
        # this is the one that matugen works with
        name = "adw-gtk3-dark";
        package = pkgs.adw-gtk3;
      };

      iconTheme = {
        # this one takes a particularly long time to build
        # 6 whole minutes to be specific
        name = "WhiteSur-grey";
        package = pkgs.whitesur-icon-theme.override {
          themeVariants = [ "grey" ];
          alternativeIcons = true;
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
