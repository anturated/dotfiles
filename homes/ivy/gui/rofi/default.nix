{ config, ... }:

{
  config = {
    programs.rofi = {
      inherit (config.ceirios.profiles.graphical) enable;
      theme = ./drun.rasi;
    };

    xdg.configFile = {
      "rofi/shared.rasi".source = ./shared.rasi;
      # "rofi/drun.rasi".source = ./rofi/drun.rasi;
      "rofi/wallpaper.rasi".source = ./wallpaper.rasi;
    };
  };
}
