{
  pkgs,
  config,
  lib,
  ...
}:

{
  config = lib.mkIf config.ceirios.profiles.graphical {
    ceirios.packages = {
      inherit (pkgs)
        # settings
        pwvucontrol
        piper

        # media viewing
        nemo
        okteta

        # tools
        transmission_4-gtk
        losslesscut-bin
        ;
    };
  };
}
