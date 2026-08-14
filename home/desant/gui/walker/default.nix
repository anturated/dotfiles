{ lib, config, ... }:

let
  inherit (lib.modules) mkIf;
  inherit (config.ceirios.profiles) graphical;
in
{
  config = mkIf graphical.enable {
    # menu shower
    services.walker = {
      enable = true;

      # skip walker --gapplication-service
      systemd.enable = true;

      # start after elephant
      enableElephantIntegration = true;

      settings = {
        theme = "ivy";
      };
    };

    # menu provider
    services.elephant = {
      enable = true;

      settings = {

      };
    };

    # elephant menus
    xdg.configFile = {
      "elephant/menus".source = ./menus;
    };
  };
}
