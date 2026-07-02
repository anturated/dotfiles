{
  pkgs,
  config,
  osConfig,
  lib,
  ...
}:

let
  inherit (config.ceirios.profiles) graphical;
  inherit (osConfig.ceirios) hardware;
  inherit (lib.attrsets) attrNames;
  inherit (lib.lists) length;

  # fallbacks just in case it's not configured
  hasMonitors = length (attrNames hardware.monitors) > 0;
  refresh =
    if hasMonitors then toString hardware.monitors.${hardware.mainMonitor}.refresh-rate else 60;

  mainMonitor = if hasMonitors then hardware.mainMonitor else "";
in
{
  ceirios.packages = {
    chwal = pkgs.writeShellApplication {
      name = "chwal";

      runtimeInputs = with pkgs; [
        jq
        rofi
        awww
        matugen
        hyprland
        findutils
        coreutils
        imagemagick
      ];

      text = ''
        CHWAL_GRAPHICAL=${if graphical.enable && hasMonitors then "1" else "0"}
        CHWAL_REFRESH=${toString refresh}
        CHWAL_MAIN_MONITOR="${mainMonitor}"
      ''
      + builtins.readFile ./chwal.sh;
    };
  };
}
