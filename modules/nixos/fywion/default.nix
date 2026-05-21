# keep this dir for my own stuff,
# use nixos/services for system stuff
{ ... }:

{
  imports = [
    ./anubis.nix
    ./forgejo.nix
    ./hello-http.nix
    ./local.nix
    ./mailserver.nix
    ./nginx.nix
    ./obsidian-livesync.nix
    ./pds.nix
    ./postgres.nix
    ./redis.nix
    ./website.nix
  ];
}
