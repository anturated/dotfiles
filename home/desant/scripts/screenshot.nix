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
      ];

      text = ''
        # cleanup
        killall -9 hyprpicker grim slurp || true

        # make sure screenshot dir exists
        screenshotDir="${config.xdg.userDirs.pictures}/screenshots"
        mkdir -p "$screenshotDir"

        # freeze
        hyprpicker -z -r &
        sleep 0.1

        # capture date
        screenshotDate="$(date +%Y-%m-%d_%H-%M-%S)"

        screenshotPath="$screenshotDir/$screenshotDate.png"

        # grab
        grim -g "$(slurp)" "$screenshotPath" || true # safeguard just in case idk

        # unfreeze
        killall -9 hyprpicker || true

        # copy, this should be the proper way to spawn wl-copy
        wl-copy -t image/png < "$screenshotPath" 2>>/tmp/wlcopy-errors.log
      '';
    };
  };
}
