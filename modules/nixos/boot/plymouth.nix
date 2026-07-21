{
  pkgs,
  lib,
  config,
  ...
}:

let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkOption mkEnableOption;
  inherit (lib.types) str;

  cfg = config.ceirios.boot.plymouth;
in
{
  options.ceirios.boot.plymouth = {
    enable = mkEnableOption ''
      boot animation, instead of boot logs.
      You can still view logs by pressing ESC'';
    theme = mkOption {
      type = str;
      default = "circle_hud";
      description = "Plymouth theme.";
    };
  };

  config.boot.plymouth = mkIf cfg.enable {
    enable = true;
    inherit (cfg) theme;

    themePackages = [
      # only install the themes we need
      (pkgs.adi1090x-plymouth-themes.override {
        selected_themes = [ cfg.theme ];
      })
    ];
  };
}
