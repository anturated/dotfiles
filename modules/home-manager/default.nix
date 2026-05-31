{ ... }:

{
  _class = "homeManager";

  imports = [
    ../shared/with-home
    ./fonts.nix
    ./environment
    ./extras.nix
    ./revision.nix
    ./software
    ./secrets.nix
  ];
}
