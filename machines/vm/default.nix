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

    users.anturated = {
      home = "desant";
    };
  };
}
