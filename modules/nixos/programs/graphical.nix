{ lib, config, ... }:

let
  inherit (lib) mkIf;
in
{
  config = mkIf config.ceirios.profiles.graphical {
    programs = {
      # we need dconf to interact with gtk
      dconf.enable = true;

      # gnome's keyring manager
      seahorse.enable = true;
    };
  };
}
