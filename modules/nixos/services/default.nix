{ ... }:

{
  imports = [
    ./kale
    ./lego.nix
    ./nginx.nix
    ./anubis.nix
    ./forgejo.nix
    ./hello-http.nix
    ./local.nix
    ./mailserver.nix
    ./obsidian-livesync.nix
    ./pds.nix
    ./postgres.nix
    ./redis.nix
    ./website.nix
  ];
}
