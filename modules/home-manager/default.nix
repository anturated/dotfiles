{ ... }:

{
  _class = "homeManager";

  imports = [
    ../shared/with-home
    ./fonts.nix
    ./environment
    ./revision.nix
    ./software
    ./secrets.nix
  ];
}
