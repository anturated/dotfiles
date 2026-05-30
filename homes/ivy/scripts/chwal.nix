{
  pkgs,
  config,
  lib,
  ...
}:

let
  inherit (config.ceirios.profiles) graphical;
in
{
  ceirios.packages = {
    chwal = (
      pkgs.writeShellScriptBin "chwal" ''
        #!/usr/bin/env bash

        WALLPAPER_DIR="$HOME/media/pictures/wallpapers/"
        SCHEME="scheme-tonal-spot"

        ALL_MONITORS=false
        IMG_ARG=""

        while [[ $# -gt 0 ]]; do
          case "$1" in
            -a|--all) ALL_MONITORS=true; shift ;;
            -*) echo "Unknown option: $1"; exit 1 ;;
            *) IMG_ARG="$1"; shift ;;
          esac
        done

        thumb_dir="$HOME/.cache/wallthumbs"
        mkdir -p "$thumb_dir"

        if [ -n "$IMG_ARG" ]; then
          img="$IMG_ARG"
        elif $ALL_MONITORS; then
          echo "chwal: -a requires an image path" >&2
          exit 1
        else
          img="$WALLPAPER_DIR$(${pkgs.findutils}/bin/find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.webp" -o -iname "*.jpeg" -o -iname "*.gif" \) \
          | while read -r file; do
            base=$(${pkgs.coreutils}/bin/basename "$file")
            thumb="$thumb_dir/$base"
            if [ ! -f "$thumb" ]; then
              printf "%s\0icon\x1fthumbnail://%s\n" "$base" "$file"
              ${pkgs.imagemagick}/bin/magick "$file"[0] -thumbnail 200x200 "$thumb" &
            else
              printf "%s\0icon\x1f%s\n" "$base" "$thumb"
            fi
          done |
          ${pkgs.rofi}/bin/rofi -dmenu \
            -theme wallpaper
          )"
        fi

        [ -z "$img" ] && exit 0

        if $ALL_MONITORS; then
          # TODO: ugly
          ${lib.optionalString graphical ''
            ${pkgs.awww}/bin/awww img "$img" \
              --transition-type any \
              --transition-fps 120 \
              --transition-duration 0.6 &
          ''}
          PRIMARY_INVOLVED=true
        else
          # Get focused monitor info
          monitor_json=$(${pkgs.hyprland}/bin/hyprctl monitors -j | ${pkgs.jq}/bin/jq -r '.[] | select(.focused == true)')

          monitor=$(echo "$monitor_json" | jq -r '.name')
          x=$(echo "$monitor_json" | ${pkgs.jq}/bin/jq -r '.x')
          y=$(echo "$monitor_json" | ${pkgs.jq}/bin/jq -r '.y')

          # Fallback
          if [ -z "$monitor" ]; then
            monitor_json=$(${pkgs.hyprland}/bin/hyprctl monitors -j | ${pkgs.jq}/bin/jq -r '.[0]')
            monitor=$(echo "$monitor_json" | ${pkgs.jq}/bin/jq -r '.name')
            x=$(echo "$monitor_json" | ${pkgs.jq}/bin/jq -r '.x')
            y=$(echo "$monitor_json" | ${pkgs.jq}/bin/jq -r '.y')
          fi

          # Set wallpaper only on that monitor
          ${lib.optionalString graphical ''
            ${pkgs.awww}/bin/awww img "$img"\
              --outputs "$monitor"\
              --transition-type any\
              --transition-fps 120\
              --transition-duration 0.6 &
          ''}
          PRIMARY_INVOLVED=false
          [ "$x" -eq 0 ] && [ "$y" -eq 0 ] && PRIMARY_INVOLVED=true
        fi

        # If monitor is at (0,0), run matugen
        if $PRIMARY_INVOLVED; then
          # lots of matugen bs
          hash=$(${pkgs.coreutils}/bin/sha1sum "$img" | ${pkgs.coreutils}/bin/cut -d' ' -f1)
          cache="$HOME/.cache/matugen/$SCHEME-$hash.json"
          echo "hash is $hash for $img"

          if [ -f "$cache" ]; then
            echo "cache exists, applying"
            ${pkgs.matugen}/bin/matugen json "$cache"
          else
            echo "cache does not exist, applying from image"
            ${pkgs.matugen}/bin/matugen image --source-color-index 0 -t "$SCHEME" "$img"

            echo "cache generating"
            hex=$(${pkgs.coreutils}/bin/mktemp)
            rgb=$(${pkgs.coreutils}/bin/mktemp)
            rgba=$(${pkgs.coreutils}/bin/mktemp)
            hsl=$(${pkgs.coreutils}/bin/mktemp)
            strip=$(${pkgs.coreutils}/bin/mktemp)

            echo "generating colors (hex)..."
            ${pkgs.matugen}/bin/matugen image --source-color-index 0 "$img" --old-json-output --dry-run -t "$SCHEME" -j hex > "$hex"
            echo "generating colors (rgb)..."
            ${pkgs.matugen}/bin/matugen image --source-color-index 0 "$img" --old-json-output --dry-run -t "$SCHEME" -j rgb > "$rgb"
            echo "generating colors (rgba)..."
            ${pkgs.matugen}/bin/matugen image --source-color-index 0 "$img" --old-json-output --dry-run -t "$SCHEME" -j rgba > "$rgba"
            echo "generating colors (hsl)..."
            ${pkgs.matugen}/bin/matugen image --source-color-index 0 "$img" --old-json-output --dry-run -t "$SCHEME" -j hsl > "$hsl"
            echo "generating colors (strip)..."
            ${pkgs.matugen}/bin/matugen image --source-color-index 0 "$img" --old-json-output --dry-run -t "$SCHEME" -j strip > "$strip"

            echo "merging..."

            ${pkgs.jq}/bin/jq -n \
              --argjson hex   "$(${pkgs.coreutils}/bin/cat "$hex")" \
              --argjson rgb   "$(${pkgs.coreutils}/bin/cat "$rgb")" \
              --argjson rgba  "$(${pkgs.coreutils}/bin/cat "$rgba")" \
              --argjson hsl   "$(${pkgs.coreutils}/bin/cat "$hsl")" \
              --argjson strip "$(${pkgs.coreutils}/bin/cat "$strip")" \
            '{
            colors:
              ($hex.colors | to_entries | map(
              . as $outer |
              {
                key: $outer.key,
                value: (
                $outer.value | to_entries | map(
                  . as $inner |
                  {
                  key: $inner.key,
                  value: {
                    hex: $hex.colors[$outer.key][$inner.key],
                    rgb: $rgb.colors[$outer.key][$inner.key],
                    rgba: $rgba.colors[$outer.key][$inner.key],
                    hsl: $hsl.colors[$outer.key][$inner.key],
                    hex_stripped: $strip.colors[$outer.key][$inner.key]
                  }
                  }
                ) | from_entries
                )
              }
              ) | from_entries)
            }
            ' > "$cache"
            ${pkgs.coreutils}/bin/rm "$hex" "$rgb" "$rgba" "$hsl" "$strip"
          fi
        fi
      ''
    );
  };
}
