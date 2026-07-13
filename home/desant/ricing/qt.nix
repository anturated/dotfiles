{
  pkgs,
  config,
  lib,
  user,
  ...
}:

let
  inherit (lib.modules) mkIf;
  inherit (lib.attrsets) recursiveUpdate;
  inherit (config.ceirios.profiles) graphical;
  inherit (config.ceirios.style) fonts;

  # TODO: find replacement or fix:
  # darkly-qt5 doesn't exist anymore,
  # and besides, darkly doesn't go too well with the matugen bs that i have.

  sharedConfig = x: {
    Appearance = {
      # matugen
      color_scheme_path = "/home/${user}/.config/qt${toString x}ct/colors/ivy.conf";
      custom_palette = true;

      # inherit icons from gtk why not
      icon_theme = "${config.gtk.iconTheme.name}";

      # no idea what this does
      standard_dialogs = "default";
    };

    # no idea what this does
    Interface = {
      activate_item_on_single_click = 1;
      buttonbox_layout = 0;
      cursor_flash_time = 1000;
      dialog_buttons_have_icons = 1;
      double_click_interval = 400;
      gui_effects = "@Invalid()";
      keyboard_scheme = 2;
      menus_have_icons = true;
      show_shortcuts_in_context_menus = true;
      stylesheets = "@Invalid()";
      toolbutton_style = 4;
      underline_shortcut = 1;
      wheel_scroll_lines = 3;
    };

    # no idea what this does
    Troubleshooting = {
      force_raster_widgets = 1;
      ignored_applications = "@Invalid()";
    };
  };
in
{
  config = mkIf graphical.enable {
    qt = {
      enable = true;
      platformTheme.name = "qtct";

      qt6ctSettings = recursiveUpdate (sharedConfig 6) {
        Appearance = {
          style = "Darkly";
        };

        Fonts = {
          # no idea what the numbers do, not gonna be the one to question it.
          fixed = "${fonts.name},${toString fonts.size},-1,5,400,0,0,0,0,0,0,0,0,0,0,1,Regular,0,0";
          general = "${fonts.name},${toString fonts.size},-1,5,400,0,0,0,0,0,0,0,0,0,0,1,Regular,0,0";
        };
      };

      qt5ctSettings = recursiveUpdate (sharedConfig 5) {
        Appearance = {
          style = "Fusion";
        };

        Fonts = {
          # no idea what the numbers do
          fixed = "${fonts.name},${toString fonts.size},-1,5,50,0,0,0,0,0";
          general = "${fonts.name},${toString fonts.size},-1,5,50,0,0,0,0,0";
        };
      };
    };

    ceirios.packages = {
      inherit (pkgs)
        darkly
        ;
    };
  };
}
