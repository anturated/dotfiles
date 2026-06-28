{ config, lib, ... }:

let
  inherit (config.ceirios.programs) defaults;
in
''
  -- software defaults
  local terminal = "${defaults.terminal}"
  local menu = "rofi -show drun"
  local browser = "vivaldi"
  local explorer = "${defaults.explorer}"

  -- misc
  local screenshotDir = "${config.xdg.userDirs.pictures}/screenshots"
''
