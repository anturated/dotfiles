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
      cpu = "amd";
    };

    users.acngku = {
      home = "ivy";
    };
  };
}
