{ config, lib, ... }:

let
  inherit (lib.modules) mkIf mkForce;
  inherit (config.ceirios.profiles) server;
in
{
  config = mkIf server.enable {
    boot = {
      loader.grub = {
        useOSProber = mkForce false;
        efiSupport = mkForce false;
      };
    };
  };
}
