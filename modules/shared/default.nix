{ ... }:

{
  imports = [
    ../../homes
    ./nix
    ./with-home
    ./users
    ./system
    ./shell.nix
    ./nixpkgs.nix
  ];
}
