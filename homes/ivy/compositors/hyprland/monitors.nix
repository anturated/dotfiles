{ osConfig, lib, ... }:

let
  inherit (lib) concatStringsSep mapAttrsToList;
  inherit (osConfig.ceirios.hardware) monitors;
  hasMonitor = monitors != { };

  # nix adds enough newlines, no need to concat with "\n"
  concatLines = concatStringsSep "";

  # this just sets the settings for any not configured monitor
  # idk if this is even mandatory because hyprland falls back
  # to wrong numbers most of the time anyways
  defaultMonitors = ''
    hl.monitor({
        output   = "",
        mode     = "preferred",
        position = "auto",
        scale    = "auto",
    })
  '';

  # turn ceirios.hardware.monitors into lua...
  # https://wiki.hypr.land/Configuring/Basics/Monitors/

  # transforms 0-3 align with our "orientation".
  # the rest is "flipped", idk what that is and who's gonna use it

  # screw trying to simplify the scaled translation.
  # ceirios.hardware.monitors.<name>.x and y have good enough descriptions on what to do

  configMonitors = concatLines (
    mapAttrsToList (name: mon: ''
      hl.monitor({
        output = "${name}",
        mode = "${toString mon.width}x${toString mon.height}@${toString mon.refresh-rate}",
        position = "${toString mon.x}x${toString mon.y}",
        transform = ${toString mon.orientation},
        scale = ${toString mon.scale},
      })
    '') monitors
  );

  # merge (and avoid too many empty lines i guess)
  allMonitors =
    if hasMonitor then
      concatLines [
        configMonitors
        defaultMonitors
      ]
    else
      defaultMonitors;
in
allMonitors
