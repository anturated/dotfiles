MY_PID=$$

# check flags
while getopts ":mgGbncHOMPlsxS" opt; do
  case $opt in
  m) # minimal
    USE_HYPR=0
    USE_MANGOHUD=0
    USE_POWER=0
    USE_PROTON_WAYLAND=0
    USE_FSR4=1
    ;;
  # env vars
  x) USE_PROTON_WAYLAND=0 ;;
  l) USE_PROTON_LOG=1 ;;
  s) USE_STEAMDECK=1 ;;
  g) # gamemode daemon
    USE_GAMEMODE=0
    USE_GAMEMODE_DAEMON=1
    ;;
  G) # gamemode both
    USE_GAMEMODE=1
    USE_GAMEMODE_DAEMON=1
    ;;
  b) # bypass: daemon + direct pid registration, no gamemoderun
    USE_GAMEMODE=0
    USE_GAMEMODE_DAEMON=0
    USE_GAMEMODE_BYPASS=1
    ;;
  n) # no gamemode
    USE_GAMEMODE=0
    USE_GAMEMODE_DAEMON=0
    USE_GAMEMODE_BYPASS=0
    ;;
  S)                     # gamescope
    USE_PROTON_WAYLAND=0 # breaks i think
    USE_GAMESCOPE=1
    ;;
  c) # customize
    USE_HYPR=0
    USE_OFFLOAD=0
    USE_GAMEMODE=0
    USE_GAMEMODE_DAEMON=0
    USE_GAMEMODE_BYPASS=0
    USE_MANGOHUD=0
    USE_POWER=0
    ;;
  H) USE_HYPR=1 ;;
  O) USE_OFFLOAD=1 ;;
  M) USE_MANGOHUD=1 ;;
  P) USE_POWER=1 ;;
  *) ;;
  esac
done
shift $((OPTIND - 1))

# cleanup trap
GM_PID=""

# shellcheck disable=SC2329
cleanup() {
  if [ -n "$GM_PID" ]; then
    kill "$GM_PID" 2>/dev/null || true
  fi
  # unregister
  dbus-send --system --print-reply \
    --dest=com.anturated.kaled \
    /com/anturated/kaled com.anturated.kaled.UnregisterClient \
    int32:"$MY_PID"
}

trap cleanup EXIT INT TERM HUP

# register in daemon for tweaks
dbus-send --system --print-reply \
  --dest=com.anturated.kaled \
  /com/anturated/kaled com.anturated.kaled.RegisterClient \
  int32:$MY_PID string:"$HYPRLAND_INSTANCE_SIGNATURE" \
  string:"$XDG_RUNTIME_DIR" \
  boolean:"$([ "$USE_HYPR" -eq 1 ] && echo true || echo false)" \
  boolean:"$([ "$USE_POWER" -eq 1 ] && echo true || echo false)"

# pop a gamemode daemon (nightreign stare)
if [ "$USE_GAMEMODE_DAEMON" -eq 1 ]; then
  gamemoded -r &
  GM_PID=$!
fi

# assemble #
CMD=("$@")
ENV_VARS=()

# proton / steam env
[ "$USE_PROTON_WAYLAND" -eq 1 ] && ENV_VARS+=("PROTON_ENABLE_WAYLAND=1")
[ "$USE_PROTON_LOG" -eq 1 ] && ENV_VARS+=("PROTON_LOG=1")
[ "$USE_STEAMDECK" -eq 1 ] && ENV_VARS+=("SteamDeck=1")
[ "$USE_NTSYNC" -eq 1 ] && ENV_VARS+=("PROTON_ENABLE_NTSYNC=1")
[ "$USE_FSR4" -eq 1 ] && ENV_VARS+=("PROTON_FSR4_UPGRADE=1")
if [ "$USE_GAMESCOPE" -eq 1 ]; then
  if [ "$USE_MANGOHUD" -eq 1 ]; then
    ENV_VARS+=("MANGOHUD=1")
    # export PATH="${pkgs.mangohud}/bin:$PATH"
  fi
  # this should kill the lag at ~24 minutes
  ENV_VARS+=("LD_PRELOAD=\"\"")
fi

# nvidia offload
if [ "$USE_OFFLOAD" -eq 1 ]; then
  ENV_VARS+=(
    "__NV_PRIME_RENDER_OFFLOAD=1"
    "__NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0"
    "__GLX_VENDOR_LIBRARY_NAME=nvidia"
    "__VK_LAYER_NV_optimus=NVIDIA_only"
  )
fi

# apply env in one go
if [ ${#ENV_VARS[@]} -gt 0 ]; then
  CMD=(env "${ENV_VARS[@]}" "${CMD[@]}")
fi

# wrappers (order matters!)
if [ "$USE_GAMESCOPE" -eq 1 ]; then
  # use default gamescope to apply args from config
  CMD=(gamescope -- "${CMD[@]}")
else
  if [ "$USE_MANGOHUD" -eq 1 ]; then
    CMD=(mangohud "${CMD[@]}")
  fi
fi

if [ "$USE_GAMEMODE" -eq 1 ]; then
  CMD=(gamemoderun "${CMD[@]}")
fi

# run #
if [ "$USE_GAMEMODE_BYPASS" -eq 1 ]; then
  "${CMD[@]}" &
  LAUNCHER_PID=$!

  BLACKLIST="^(steam|steamwebhelper|services|winedevice|svchost|plugplay|explorer|rpcss|tabtip|conhost|wineboot|rundll32|winemenubuilder|upc)\.exe$"

  declare -A seen
  while kill -0 $LAUNCHER_PID 2>/dev/null; do
    while IFS= read -r pid; do
      if [ -n "$pid" ] && [ -z "${seen[$pid]}" ] && [ "$pid" != "$$" ]; then
        PROC_NAME=$(ps -p "$pid" -o comm= 2>/dev/null | xargs)

        # Only register if it's an .exe and NOT in the blacklist
        if [[ "${PROC_NAME,,}" =~ \.exe$ ]] && [[ ! "${PROC_NAME,,}" =~ $BLACKLIST ]]; then
          seen[$pid]=1
          gamemoded -r"$pid"
        fi
      fi
    done < <(pgrep -f ".exe" 2>/dev/null)
    sleep 1
  done

  wait $LAUNCHER_PID
  exit $?
else
  "${CMD[@]}"
  exit $?
fi
