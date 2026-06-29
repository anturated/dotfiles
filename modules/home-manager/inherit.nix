{ osConfig, ... }:

{
  # for some reason i can't have this in profiles.nix anymore
  ceirios.profiles = {
    inherit (osConfig.ceirios.profiles)
      graphical
      headless
      workstation
      laptop
      gaming
      ;
  };
}
