{ lib, ... }:

let
  inherit (lib.options) mkOption;
  inherit (lib.types) str enum float;
in
{
  options.ceirios.hardware = {
    keyboard = {
      layouts = mkOption {
        type = str;
        default = "us";
        example = "us,de";
        description = ''
          `XkbLayout` layouts,
          comma separated if you need multiple.
          No spaces.
        '';
      };

      switch = mkOption {
        type = enum [
          "alt+shift"
          "ctrl+shift"
          "super+space"
        ];
        default = "alt+shift";
        description = ''
          Layout switch method.
          Unfortunately either mutually exclusive or flaky on hyprland.
          So you get to pick only one.
        '';
      };
    };

    mouse = {
      accel = mkOption {
        type = enum [
          "adaptive"
          "flat"
        ];
        default = "flat";
        description = "Mouse acceleration profile.";
      };

      sensitivity = mkOption {
        type = float;
        default = 0.0;
        description = ''
          Mouse sensitivity.
          Hyprland clamps between -1.0 and 1.0.
        '';
      };
    };
  };
}
