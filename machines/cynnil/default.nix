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
      ip6 = "2a01:4f8:1c18:ca88::/64";
      gateway6 = "fe80::1";
      netmask = "255.255.255.255";
    };

    users.anturated = { };

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

      # web services #
      nginx.enable = true;
      anubis.enable = true;
      redis.enable = true;
    };
  };
}
