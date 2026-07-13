SCHEME="scheme-tonal-spot"
DURATION="0.6"
# do this because it won't resolve pictures dir from hyprland keybind
WALLPAPER_DIR="$HOME/media/pictures/wallpapers/"

ALL_MONITORS=false
IMG_ARG=""

# extract args #

while [[ $# -gt 0 ]]; do
  case "$1" in
  -a | --all)
    ALL_MONITORS=true
    shift
    ;;
  -*)
    echo "Unknown option: $1"
    exit 1
    ;;
  *)
    IMG_ARG="$1"
    shift
    ;;
  esac
done

# set up thumbnails dir #

thumb_dir="$HOME/.cache/wallthumbs"
mkdir -p "$thumb_dir"

# check/process args #

if [ -n "$IMG_ARG" ]; then
  img="$IMG_ARG"
elif $ALL_MONITORS; then
  echo "chwal: -a requires an image path" >&2
  exit 1
else
  # try get an image from user
  img="$WALLPAPER_DIR$(
    # scan wallpapers dir
    find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.webp" -o -iname "*.jpeg" -o -iname "*.gif" \) |
      # extract name
      while read -r file; do
        base=$(basename "$file")
        thumb="$thumb_dir/$base"
        # generate thumbnail if not present
        if [ ! -f "$thumb" ]; then
          printf "%s\0icon\x1fthumbnail://%s\n" "$base" "$file"
          magick "$file"[0] -thumbnail 200x200 "$thumb" &
        else
          printf "%s\0icon\x1f%s\n" "$base" "$thumb"
        fi
      done |
      rofi -dmenu \
        -theme wallpaper
  )"
fi

# if we didn't get an image we do nothing
[ -z "$img" ] && exit 0

# set wallpaper #

if $ALL_MONITORS; then
  if [ "$CHWAL_GRAPHICAL" -eq 1 ]; then
    awww img "$img" \
      --transition-type any \
      --transition-fps "$CHWAL_REFRESH" \
      --transition-duration "$DURATION" &
  fi

  PRIMARY_INVOLVED=true
else
  # get focused monitor info
  monitor_json=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true)')
  monitor=$(echo "$monitor_json" | jq -r '.name')

  # set wallpaper only on that monitor
  if [ "$CHWAL_GRAPHICAL" -eq 1 ]; then
    awww img "$img" \
      --outputs "$monitor" \
      --transition-type any \
      --transition-fps "$CHWAL_REFRESH" \
      --transition-duration "$DURATION" &
  fi

  PRIMARY_INVOLVED=false
  [ "$monitor" == "$CHWAL_MAIN_MONITOR" ] && PRIMARY_INVOLVED=true
fi

# if run on primary monitor run matugen
if $PRIMARY_INVOLVED; then
  # get image hash
  hash=$(sha1sum "$img" | cut -d' ' -f1)
  mkdir -p "$HOME/.cache/matugen"
  cache="$HOME/.cache/matugen/$SCHEME-$hash.json"
  echo "hash is $hash for $img"

  # check if cache for the image exists
  if [ -f "$cache" ]; then
    echo "cache exists, applying"
    matugen json "$cache"
  else
    # if not, ball it and apply image for speed
    # matugen cache generation takes like 10 seconds
    echo "cache does not exist, applying from image"
    matugen image --source-color-index 0 -t "$SCHEME" "$img"

    # make temps
    echo "cache generating"
    hex=$(mktemp)
    rgb=$(mktemp)
    rgba=$(mktemp)
    hsl=$(mktemp)
    strip=$(mktemp)

    # generate json for every possible color format
    echo "generating colors (hex)..."
    matugen image --source-color-index 0 "$img" --old-json-output --dry-run -t "$SCHEME" -j hex >"$hex"
    echo "generating colors (rgb)..."
    matugen image --source-color-index 0 "$img" --old-json-output --dry-run -t "$SCHEME" -j rgb >"$rgb"
    echo "generating colors (rgba)..."
    matugen image --source-color-index 0 "$img" --old-json-output --dry-run -t "$SCHEME" -j rgba >"$rgba"
    echo "generating colors (hsl)..."
    matugen image --source-color-index 0 "$img" --old-json-output --dry-run -t "$SCHEME" -j hsl >"$hsl"
    echo "generating colors (strip)..."
    matugen image --source-color-index 0 "$img" --old-json-output --dry-run -t "$SCHEME" -j strip >"$strip"

    # merge it all into one file
    echo "merging..."
    jq -n \
      --argjson hex "$(cat "$hex")" \
      --argjson rgb "$(cat "$rgb")" \
      --argjson rgba "$(cat "$rgba")" \
      --argjson hsl "$(cat "$hsl")" \
      --argjson strip "$(cat "$strip")" \
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
    ' >"$cache" # write to our cache file

    # remove temps
    rm "$hex" "$rgb" "$rgba" "$hsl" "$strip"
  fi
fi
