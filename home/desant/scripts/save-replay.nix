{
  pkgs,
  config,
  lib,
  ...
}:

let
  inherit (lib.modules) mkIf;
  inherit (config.ceirios.profiles) graphical;
in
{
  ceirios.packages = mkIf graphical.enable {
    save-replay = pkgs.writeShellApplication {
      name = "save-replay";

      runtimeInputs = with pkgs; [
        libnotify
      ];

      text = ''
        if pkill -SIGUSR1 gpu-screen-reco; then
          notify-send "Replay Saved!"
        else
          notify-send "Replay NOT Saved!"
        fi
      '';
    };
  };
}
