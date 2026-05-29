{ ... }:

{
  _class = "nixos";

  imports = [
    ../base
    ./boot
    ./environment
    ./hardware
    ./headless.nix
    ./kernel
    ./networking
    ./security
    ./services
    ./secrets.nix
    ./software
    ./system
    ./users.nix

    ./extras.nix
  ];
}
