{
  pkgs,
  config,
  lib,
  ...
}:

let
  inherit (lib.modules) mkIf;
  inherit (config.ceirios.profiles) graphical;
in
{
  config = mkIf graphical.enable {
    ceirios.packages = {
      inherit (pkgs)
        # settings
        pwvucontrol
        piper

        # media viewing
        okteta

        # tools
        transmission_4-gtk
        losslesscut-bin
        ;
    };
  };
}
