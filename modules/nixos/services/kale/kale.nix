{
  pkgs,
  config,
  lib,
  ...
}:

let
  inherit (lib.modules) mkIf;
  inherit (config.ceirios.profiles) gaming;
  hasOffload = config.ceirios.hardware.prime == "offload";
  useOffload = if hasOffload then "1" else "0";
in
{
  ceirios.packages = mkIf gaming.enable {
    kale = pkgs.writeShellApplication {
      name = "kale";

      runtimeInputs = with pkgs; [
        gamemode
        mangohud
      ];

      text = ''
        # defaults
        USE_HYPR=1
        USE_POWER=1
        USE_NTSYNC=1

        USE_OFFLOAD=${useOffload}

        USE_GAMEMODE=1
        USE_GAMEMODE_DAEMON=0
        USE_GAMEMODE_BYPASS=0

        USE_MANGOHUD=1

        USE_FSR4=1 # why not
        USE_PROTON_WAYLAND=1
        USE_PROTON_LOG=0
        USE_STEAMDECK=0
        USE_GAMESCOPE=0
      ''
      + builtins.readFile ./kale.sh;
    };
  };
}
