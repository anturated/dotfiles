{ ... }:

{
  imports = [ ./hardware.nix ];

  ceirios = {
    profiles = {
      graphical.enable = true;
      gaming.enable = true;
      workstation.enable = true;
    };

    hardware = {
      cpu = "amd";
    };

    users.acngku.home = "ivy";
  };
}
