# inspired by hyprpicker but that one randomly freezes my screen so nuh uh

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
    ceirios-screenshot = pkgs.writeShellApplication {
      name = "screenshot";

      runtimeInputs = with pkgs; [
        hyprpicker
        grim
        slurp
        killall
        wl-clipboard
        jq
      ];

      text = ''
        full=false

        # parse args
        while getopts ":f" opt; do
          case "$opt" in
            f) full=true ;;
            *) ;;
          esac
        done

        # cleanup
        killall -9 hyprpicker grim slurp || true

        # make sure screenshot dir exists
        screenshotDir="${config.xdg.userDirs.pictures}/screenshots"
        mkdir -p "$screenshotDir"

        # capture date
        screenshotDate="$(date +%Y-%m-%d_%H-%M-%S)"

        screenshotPath="$screenshotDir/$screenshotDate.png"

        if $full; then
          # grab monitor
          monitor="$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .name')"
          grim -o "$monitor" "$screenshotPath" || true
        else
          # freeze
          hyprpicker -z -r &
          sleep 0.1

          # grab
          grim -g "$(slurp)" "$screenshotPath" || true # safeguard just in case idk

          # unfreeze
          killall -9 hyprpicker || true
        fi

        # copy, this should be the proper way to spawn wl-copy
        wl-copy -t image/png < "$screenshotPath" 2>>/tmp/wlcopy-errors.log
      '';
    };
  };
}
