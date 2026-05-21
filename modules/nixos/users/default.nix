{ ... }:

{
  imports = [
    ./anturated.nix
    ./desant.nix
    ./root.nix
    ./wizard.nix
  ];

  # we define users in the config, and it should stay that way
  config = {
    users.mutableUsers = false;
  };
}
