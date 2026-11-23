{ pkgs, ... }:

{
  home-manager.users.desant = {
    ceirios.packages = {
      inherit (pkgs) olympus;
    };
  };

  # enable solaar for mouse customization
  hardware.logitech.wireless = {
    enable = true;
    enableGraphical = true;
  };
}
