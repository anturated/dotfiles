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
    playalbum = pkgs.writeShellScriptBin "playalbum" ''
      #!/usr/bin/env bash
      set -euo pipefail

      dir="$1"

      # TODO: add video formats and change animelist to use this
      mapfile -t tracks < <(
        find "$dir" -maxdepth 1 -type f \
          \( -iname '*.flac' -o -iname '*.mp3' -o -iname '*.ogg' -o -iname '*.opus' \
             -o -iname '*.wav' -o -iname '*.m4a' -o -iname '*.aac' -o -iname '*.wv' -o -iname '*.ape' \) \
        | sort
      )

      exec mpv "''${tracks[@]}"
    '';
  };
}
