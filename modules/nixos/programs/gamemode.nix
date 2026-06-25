{ config, ... }:

{
  # gamemode just has to be system level for some reason
  programs.gamemode = {
    enable = config.ceirios.profiles.gaming;
    enableRenice = true;
  };
}
