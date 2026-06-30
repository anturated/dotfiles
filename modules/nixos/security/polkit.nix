{ config, ... }:

{
  security = {
    polkit.enable = true;

    # this should only be installed on graphical systems
    soteria = {
      inherit (config.ceirios.profiles.graphical) enable;
    };
  };
}
