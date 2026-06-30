{ config, ... }:

{
  # gamemode just has to be system level for some reason
  programs.gamemode = {
    inherit (config.ceirios.profiles.gaming) enable;
    enableRenice = true;
  };
}
