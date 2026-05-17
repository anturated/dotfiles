{ config, lib, ... }:

let
  inherit (config.ceirios.software) defaults;
in
''
  -- bg stuff
  local bar = "qs -c ivy -d"
  local wallpaper = "awww-daemon"
  local filter = "hyprsunset"
  local polkit = "soteria"

  -- software defaults
  local terminal = "${defaults.terminal}"
  local menu = "rofi -show drun"
  local browser = "vivaldi"

  -- misc
  local screenshotDir = "${config.xdg.userDirs.pictures}/screenshots"
''
