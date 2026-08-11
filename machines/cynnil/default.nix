{ ... }:

{
  imports = [
    ./hardware.nix
  ];

  ceirios = {
    profiles = {
      headless.enable = true;
      server.enable = true;
      qemuGuest.enable = true;
    };

    hardware.cpu = "intel";

    networking = {
      interface = "eth0";

      ip = "178.105.140.238";
      gateway = "172.31.1.1";
      netmask = "255.255.255.255";

      ip6 = "2a01:4f8:1c18:ca88::1";
      gateway6 = "fe80::1";
      prefix6 = 64;
    };

    users.anturated = {
      home = "desant";
    };

    system.stateVersion = "25.11";

    # note: this VPS has UEFI boot so no grub.

    services = {
      # self-hosted #
      anturated-website.enable = true;
      mailserver.enable = true;
      mailserver.webui.enable = true;
      forgejo.enable = true;
      woodpecker.enable = true;
      jellyfin.enable = true;
      matrix.enable = true;
      matrixrtc.enable = true;
      coturn.enable = true;
      pds.enable = true;
      adguard.enable = true;
      gatus.enable = true;
      vaultwarden.enable = true;
      obsidian-livesync.enable = true;
      wakapi.enable = true;

      # web services #
      nginx.enable = true;
      anubis.enable = true;
      redis.enable = true;
    };
  };
}
