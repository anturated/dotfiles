{ config, ... }:

let
  inherit (config.ceirios.profiles) server;
in
{
  networking.stevenblack = {
    enable = !server.enable;

    block = [
      "fakenews"
      "gambling"
      "porn"
      # "social"
    ];
  };
}
