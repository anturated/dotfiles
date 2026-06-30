{ lib, config, ... }:

let
  inherit (lib) optionals;
  inherit (config.ceirios.profiles) gaming;
in
{
  boot.kernelModules = optionals gaming.enable [ "ntsync" ];
}
