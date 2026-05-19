{
  pkgs,
  config,
  lib,
  ...
}:

{
  home.packages = lib.optionals config.ceirios.profiles.graphical [
    (pkgs.writeShellScriptBin "animelist" ''
      #!/usr/bin/env bash
      set -euo pipefail

      # $XDG_VIDEOS_DIR won't resolve from hyprlands keybind
      ANIME_DIR="${config.xdg.userDirs.videos}/anime/"

      anime="$ANIME_DIR$( \
        find "$ANIME_DIR" -type d -mindepth 1 |
        while read -r dir; do
          echo $(basename "$dir")
        done |
        rofi -dmenu
      )"

      episodes=()
      while read -r ep; do
        episodes+=("$ep")
      done < <(find "$anime" -type f | sort -V)

      mpv "''${episodes[@]}"
    '')
  ];
}
