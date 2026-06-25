{ ... }:

{
  _class = "nixos";

  imports = [
    ../shared
    ./boot
    ./environment
    ./hardware
    ./headless.nix
    ./kernel
    ./networking
    ./programs
    ./security
    ./services
    ./secrets.nix
    ./system
    ./users.nix

    ./extras.nix
  ];
}
