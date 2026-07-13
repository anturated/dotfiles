{ ... }:

{
  imports = [
    ./hardware.nix
    ./users.nix
  ];

  ceirios = {
    profiles = {
      laptop.enable = true;
      workstation.enable = true;
      graphical.enable = true;
      gaming.enable = true;
      virtualisation.enable = true;
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

      keyboard.layouts = "us,ru,pl,ua";
    };

    users.desant = {
      secrets = {
        wakatime = true;
      };
    };

    system = {
      lix.enable = true;
      flakeDir = "$HOME/dev/dotfiles";
    };
  };
}
