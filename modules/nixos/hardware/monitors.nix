{ lib, config, ... }:

let
  inherit (lib.lists) sort head;
  inherit (lib.options) mkOption literalExpression;
  inherit (lib.attrsets) attrValues;
  inherit (lib.types)
    str
    attrsOf
    submodule
    int
    float
    ;

  getClosestTo00 =
    let
      # use values because names MAY be overridden
      mons = attrValues config.ceirios.hardware.monitors;
      sorted = sort (a: b: (a.x + a.y) < (b.x + b.y)) mons;
      closestTo00 = head sorted;
    in
    closestTo00;
in
{
  options.ceirios.hardware = {
    mainMonitor = mkOption {
      type = str;
      default = getClosestTo00.name;
      description = ''
        Main monitor's name.
        Defaults to whatever monitor is closest to (0, 0).
      '';
    };

    monitors = mkOption {
      type = attrsOf (
        submodule (
          { name, ... }:
          {
            options = {
              name = mkOption {
                type = str;
                default = name;
                description = "Monitor name";
                example = "DP-1";
              };

              width = mkOption {
                type = int;
                default = 1920;
                description = "Width of the monitor in pixels";
                example = 1920;
              };

              height = mkOption {
                type = int;
                default = 1080;
                description = "Height of the monitor in pixels";
                example = 1080;
              };

              refresh-rate = mkOption {
                type = int;
                default = 60;
                description = "Refresh rate of the monitor in hz";
                example = 144;
              };

              orientation = mkOption {
                type = int;
                default = 0;
                description = "How many times the monitor is rotated 90 degrees clockwise.";
                example = 3;
              };

              x = mkOption {
                type = int;
                default = 0;
                description = ''
                  Scaled horizontal offset in pixels.

                  Meaning if you want your 4K monitor with scale 2
                  to the left of your 1080p one, you’d use x = 1920
                  for the second screen (3840 / 2).
                  If the monitor is also rotated 90 degrees (vertical),
                  you’d use x = 1080 (2160 / 2)
                '';
                example = -1920;
              };

              y = mkOption {
                type = int;
                default = 0;
                description = ''
                  Scaled horizontal offset in pixels.

                  Meaning if you want your 4K monitor with scale 2
                  to the top of your 1080p one, you’d use y = -1080
                  for the second screen (2160 / 2).
                  If the monitor is also rotated 90 degrees (vertical),
                  you’d use y = -1920 (3840 / 2)
                '';
                example = 700;
              };

              scale = mkOption {
                type = float;
                default = 1.0;
                description = "Scale of your monitor";
                example = 1.5;
              };
            };
          }
        )
      );

      description = ''
        Monitors config. You usually want this set up. Get monitor names with `hyprctl monitors` or similar.
      '';

      example = literalExpression ''
        monitors = {
          HDMI-1 = { }; # defaults to 1080p @ 60hz
          DP-1 = {
            width = 3440;
            height = 1440;
            refresh-rate = 144;
          };
        };'';
    };
  };
}
