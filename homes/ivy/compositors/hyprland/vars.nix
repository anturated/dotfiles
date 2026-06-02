{ config, lib, ... }:

let
  inherit (config.ceirios.software) defaults;
in
''
  -- bg stuff
  local wallpaper = "awww-daemon"
  local filter = "hyprsunset"

  -- software defaults
  local terminal = "${defaults.terminal}"
  local menu = "rofi -show drun"
  local browser = "vivaldi"

  -- misc
  local screenshotDir = "${config.xdg.userDirs.pictures}/screenshots"
''
