{ ... }:

{
  _class = "homeManager";

  imports = [
    ../shared/with-home
    ./fonts.nix
    ./environment
    ./programs
    ./revision.nix
    ./secrets.nix
  ];
}
