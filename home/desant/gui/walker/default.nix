{
  lib,
  config,
  pkgs,
  ...
}:

let
  inherit (lib.modules) mkIf;
  inherit (config.ceirios.profiles) graphical;

  # provider list, don't trust elephant list:
  # https://github.com/abenz1267/elephant/tree/master/internal/providers
  enabledProviders = [
    "bluetooth"
    "calc"
    "clipboard"
    "desktopapplications"
    "files"
    "menus"
    "providerlist"
    "runner"
    "symbols"
    "unicode"
    "wireplumber"
  ];
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

        providers.max_results_provider = {
          "menus:wallpapers" = 999; # i wanna see all of em
        };
      };
    };

    # menu provider
    services.elephant = {
      enable = true;

      # rebuilding this from source sucks but WHO NEEDS AUR SEARCH ON NIXOS
      package = pkgs.elephant.override { inherit enabledProviders; };
    };

    # elephant menus
    xdg.configFile = {
      "elephant/menus".source = ./menus;
    };
  };
}
