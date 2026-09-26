{ lib, config, ... }:

let
  inherit (lib.modules) mkIf;
  inherit (config.ceirios.profiles) graphical;
in
{
  config = mkIf graphical.enable {
    services.awww = {
      enable = true;
    };
  };
}
