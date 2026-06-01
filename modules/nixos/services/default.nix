{ ... }:

{
  imports = [
    ./kale
    ./lego.nix
    ./nginx.nix
    ./anubis.nix
    ./forgejo.nix
    ./mailserver.nix
    ./obsidian-livesync.nix
    ./pds.nix
    ./postgres.nix
    ./redis.nix
    ./website.nix
  ];
}
