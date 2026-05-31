{
  # these will get imported by both nixos and home-manager
  # allows to do ceirios.packages on home-manager
  imports = [
    ./profiles.nix
    ./packages.nix
  ];
}
