{ config, ... }:

{
  services.hyprsunset = {
    inherit (config.ceirios.profiles.graphical) enable;

    settings = { };
  };
}
