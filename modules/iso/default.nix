{ modulesPath, ... }:

{
  imports = [
    # get an installer profile from nixpkgs to base the Isos off of
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal-new-kernel.nix"

    ./boot.nix
    ./console.nix
    ./fixes.nix
    ./image.nix
    ./networking.nix
    ./nix.nix
    ./nixpkgs.nix
    ./programs.nix
    ./space.nix
  ];
}
