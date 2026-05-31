{
  pkgs,
  lib,
  config,
  ...
}:

let
  inherit (lib) mkOption mkEnableOption types;
  inherit (types) str listOf;

  cfg = config.ceirios.boot.plymouth;
in
{
  options.ceirios.boot.plymouth = {
    enable = mkEnableOption "Enable boot animation";
    theme = mkOption {
      type = str;
      default = "circle_hud";
      description = "Plymouth theme.";
    };

    themes = mkOption {
      type = listOf str;
      default = [ "circle_hud" ];
      description = "Extra themes to get.";
    };
  };

  config.boot = {
    # optional plymouth
    plymouth = lib.mkIf cfg.enable {
      enable = true;
      inherit (cfg) theme;
      themePackages = with pkgs; [
        # By default we would install all themes
        (adi1090x-plymouth-themes.override {
          selected_themes = cfg.themes;
        })
      ];
    };
  };
}
