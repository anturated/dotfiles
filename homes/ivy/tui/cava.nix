{ config, ... }:

{
  programs.cava = {
    inherit (config.ceirios.profiles.graphical) enable;

    settings = {
      color = {
        theme = "ivy";
      };
    };
  };
}
