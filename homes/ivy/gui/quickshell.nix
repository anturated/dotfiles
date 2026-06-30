{ config, inputs, ... }:

{
  imports = [ inputs.eiddew.homeModules.default ];

  programs.eiddew = {
    inherit (config.ceirios.profiles.graphical) enable;
  };
}
