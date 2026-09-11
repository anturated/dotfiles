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
    mute-active = pkgs.writeShellScriptBin "mute-active" ''
      pid=$(hyprctl activewindow -j | jq -r '.pid')

      if [[ -z "$pid" || "$pid" == "null" ]]; then
        notify-send "mute-focused" "No focused window" 2>/dev/null || true
        exit 1
      fi

      collect_pids() {
        local p=$1
        echo "$p"
        local child
        for child in $(pgrep -P "$p" 2>/dev/null || true); do
            collect_pids "$child"
        done
      }

      mapfile -t pids < <(collect_pids "$pid")
      pid_json=$(printf '%s\n' "''${pids[@]}" | jq -R . | jq -s .)

      mapfile -t ids < <(
        pw-dump | jq -r --argjson pids "$pid_json" '
          .[] | select(.info.props."media.class" == "Stream/Output/Audio")
          | select(.info.props."application.process.id" | tostring as $p | $pids | index($p))
          | .id
        '
      )

      if [[ "''${#ids[@]}" -eq 0 ]]; then
        exit 0
      fi

      for id in "''${ids[@]}"; do
        wpctl set-mute "$id" toggle
      done
    '';
  };
}
