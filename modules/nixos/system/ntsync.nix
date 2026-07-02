{ lib, config, ... }:

let
  inherit (lib.lists) optionals;
  inherit (config.ceirios.profiles) gaming;
in
{
  boot.kernelModules = optionals gaming.enable [ "ntsync" ];
}
