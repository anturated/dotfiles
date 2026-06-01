{ ... }:

{
  imports = [
    ./hardware.nix
  ];

  ceirios = {
    profiles = {
      laptop = true;
      workstation = true;
      graphical = true;
      gaming = true;
    };

    hardware = {
      cpu = "amd";
      gpu = "nv-hybrid";
      bluetooth.enable = true;

      busIds = {
        primary = "6:0:0";
        discrete = "1:0:0";
      };

      monitors = {
        eDP-2.refresh-rate = 120;

        DP-1 = {
          x = 1920;
          y = 700;
        };
      };
    };

    system = {
      users.desant = { };
      lix.enable = true;
      stateVersion = "25.05";
      flakeDir = "$HOME/dev/dotfiles";
    };
  };
}
