{ lib, config, ... }:

let
  inherit (lib.modules) mkIf;
  inherit (config.ceirios.profiles) gaming;
in
{
  config = mkIf gaming.enable {
    # this service proxies x11 tray icons to wayland tray
    # removing the need for that one annoying window wine creates for tray on wayland
    services.snixembed = {
      enable = true;
    };
  };
}
