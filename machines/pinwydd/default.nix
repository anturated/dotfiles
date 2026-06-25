{ ... }:

{
  imports = [
    ./hardware.nix
  ];

  ceirios = {
    profiles = {
      headless = true;
      qemuGuest = true;
    };

    hardware.cpu = "amd";

    networking = {
      interface = "ens3";
      ip = "82.38.2.58";
      gateway = "62.141.62.1";
      netmask = "255.255.255.0";
    };

    users.anturated = { };
  };
}
