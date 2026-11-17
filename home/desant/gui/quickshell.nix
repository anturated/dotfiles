{ config, inputs, ... }:

{
  imports = [ inputs.ifori.homeModules.default ];

  programs.ifori = {
    inherit (config.ceirios.profiles.graphical) enable;
  };
}
