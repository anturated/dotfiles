{ config, ... }:

let
  inherit (config.ceirios.software.defaults) terminal;
  inherit (config.ceirios.profiles) graphical;
in
{
  programs.kitty = {
    enable = graphical && (terminal == "kitty");
    settings = {
      include = "current-theme.conf";

      # cursor
      cursor_shape = "underline";
      cursor_blink_interval = 0;

      # window
      remember_window_size = "no";
      initial_window_width = "65c";
      initial_window_height = "17c";
      confirm_os_window_close = 0;

      # tab bar
      tab_bar_min_tabs = 2;
      tab_bar_edge = "top";
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
      tab_title_template = "{title}{' :{}:'.format(num_windows) if num_windows > 1 else ''}";

      # misc
      background_opacity = 0.9;
      allow_remote_control = "yes";

      # this spawns literally 500k watchers for some reason
      # and fills inotify limits
      auto_reload_config = -1;
    };

    font = {
      name = config.ceirios.style.fonts.name;
      size = config.ceirios.style.fonts.size;
    };

    extraConfig = ''
      bold_font        ${config.ceirios.style.fonts.bold}
      italic_font      ${config.ceirios.style.fonts.italic}
      bold_italic_font ${config.ceirios.style.fonts.bold-italic}
      text_thickness 1.3
      symbol_map U+E000-U+F8FF,U+100000-U+10FFFF Symbols Nerd Font
    '';
  };
}
