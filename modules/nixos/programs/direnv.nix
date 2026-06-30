{ config, ... }:

{
  programs.direnv = {
    inherit (config.ceirios.profiles.workstation) enable;
    enableBashIntegration = true; # see note on other shells below
    nix-direnv.enable = true;
  };
}
