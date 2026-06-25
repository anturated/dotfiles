# shared software between homes
{ ... }:

{
  imports = [
    ./defaults.nix
    ./gpg-agent.nix
  ];
}
