{ lib, config, ... }:

{
  config = lib.mkIf config.ceirios.profiles.graphical {
    services.hyprsunset = {
      enable = true;

      settings = { };
    };
  };
}
