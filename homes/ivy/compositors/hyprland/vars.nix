{
  config,
  lib,
  osConfig,
  ...
}:

let
  inherit (config.ceirios.programs) defaults;

  layout_kbo =
    {
      "alt+shift" = "grp:alt_shift_toggle";
      "ctrl+shift" = "grp:ctrl_shift_toggle";
      "super+space" = "grp:win_space_toggle";
    }
    .${osConfig.ceirios.hardware.keyboard.switch};
in
''
  -- software defaults
  local terminal = "${defaults.terminal}"
  local menu = "rofi -show drun"
  local browser = "vivaldi"
  local explorer = "${defaults.explorer}"

  -- hardware
  local layouts = "${osConfig.ceirios.hardware.keyboard.layouts}"
  local layout_kbo = "${layout_kbo}"
  local sensitivity = ${toString osConfig.ceirios.hardware.mouse.sensitivity}
  local accel = "${osConfig.ceirios.hardware.mouse.accel}"

  -- misc
  local screenshotDir = "${config.xdg.userDirs.pictures}/screenshots"
''
