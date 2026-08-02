{ ... }:

{
  imports = [
    ./kale
    ./gatus
    ./adguard.nix
    ./lego.nix
    ./nginx.nix
    ./anubis.nix
    ./forgejo
    ./jellyfin.nix
    ./mailserver.nix
    ./obsidian-livesync.nix
    ./pds.nix
    ./postgres.nix
    ./redis.nix
    ./website.nix
    ./woodpecker.nix
    ./matrix
    ./vaultwarden.nix
    ./wakapi.nix
    ./tailscale.nix
  ];
}
