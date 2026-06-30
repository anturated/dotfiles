{ lib, config, ... }:

let
  inherit (lib) mkIf;
  inherit (config.ceirios.profiles) graphical;
in
{
  config = mkIf graphical.enable {
    programs = {
      # we need dconf to interact with gtk
      dconf.enable = true;

      # gnome's keyring manager
      seahorse.enable = true;
    };
  };
}
