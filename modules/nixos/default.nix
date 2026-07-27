{ ... }:

{
  _class = "nixos";

  imports = [
    ../shared
    ./boot
    ./environment
    ./hardware
    ./kernel
    ./networking
    ./programs
    ./security
    ./services
    ./secrets.nix
    ./system
    ./users.nix
    ./performance.nix

    ./extras.nix
  ];
}
