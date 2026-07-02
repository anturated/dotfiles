{ lib, config, ... }:

let
  inherit (lib.modules) mkIf mkMerge;
  inherit (lib.attrsets) genAttrs;
  inherit (config.ceirios.profiles) graphical;

  services = [
    "login"
    "greetd"
    "tuigreet"
  ];

  mkService = {
    enableGnomeKeyring = true;
    gnupg = {
      enable = true;
    };
  };
in
{
  security.pam = mkMerge [
    {
      # allow screenlocks to unlock gpg & keyring
      services = {
        swaylock.text = "auth include login";
        gtklock.text = "auth include login";
      };
    }

    (mkIf graphical.enable {
      services = genAttrs services (_: mkService);
    })
  ];
}
