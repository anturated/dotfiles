{ ... }:

{
  imports = [
    ./config.nix
    ./networkManager.nix
    ./openssh.nix
    ./systemd.nix
    ./stevenblack.nix
  ];

  # set in mkHost to avoid duplication
  # networking = {
  #   hostName = host;
  # };
}
