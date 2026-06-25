{ config, ... }:

{

  programs.direnv = {
    enable = config.ceirios.profiles.workstation;
    enableBashIntegration = true; # see note on other shells below
    nix-direnv.enable = true;
  };
}
