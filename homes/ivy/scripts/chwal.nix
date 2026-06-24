{
  pkgs,
  config,
  osConfig,
  ...
}:

let
  inherit (config.ceirios.profiles) graphical;
  inherit (osConfig.ceirios) hardware;
in
{
  ceirios.packages = {
    chwal = pkgs.writeShellApplication {
      name = "chwal";

      runtimeInputs = with pkgs; [
        jq
        rofi
        awww
        hyprland
        findutils
        coreutils
        imagemagick
      ];

      text = ''
        CHWAL_GRAPHICAL=${if graphical then "1" else "0"}
        CHWAL_REFRESH=${toString hardware.monitors.${hardware.mainMonitor}.refresh-rate}
        CHWAL_MAIN_MONITOR="${hardware.mainMonitor}"
      ''
      + builtins.readFile ./chwal.sh;
    };
  };
}
