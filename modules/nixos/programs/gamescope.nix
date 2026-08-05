{ lib, config, ... }:

let
  inherit (lib.modules) mkIf;

  inherit (config.ceirios.hardware) monitors mainMonitor;
  inherit (config.ceirios.profiles) gaming;

  mon = monitors.${mainMonitor};
in
{
  config = mkIf gaming.enable {
    # i'm leaving it here because it has gamescope in the name
    programs.steam.gamescopeSession.enable = true;

    programs.gamescope = {
      enable = true;
      args = lib.mkIf (monitors != { }) [
        # window size
        "-W"
        "${toString mon.width}"
        "-H"
        "${toString mon.height}"

        # game resolution (only used in upscaling)
        # "-w"
        # "${toString mainMonitor.width}"
        # "-h"
        # "${toString mainMonitor.height}"

        # frame cap
        "-r"
        "${toString mon.refresh-rate}"

        # wayland stuff
        "--backend"
        "wayland"
        "--expose-wayland" # PROTON_ENABLE_WAYLAND analogue?

        "--mangoapp"

        # steam deck vibrancy
        "--sdr-gamut-wideness"
        "1"
      ];
    };
  };
}
