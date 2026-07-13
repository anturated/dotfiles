{ ... }:

{
  imports = [
    ../../home
    ./nix
    ./with-home
    ./users
    ./system
    ./shell.nix
    ./nixpkgs.nix
  ];
}
