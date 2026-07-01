{ ... }:

{
  imports = [ ./hardware.nix ];

  ceirios = {
    profiles = {
      laptop.enable = true;
      workstation.enable = true;
      graphical.enable = true;
      gaming.enable = true;
    };

    hardware = {
      cpu = "intel";
      gpu = "nvidia";
      bluetooth.enable = true;
    };

    users.acngku = {
      home = "ivy";
    };
  };
}
