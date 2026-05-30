{ config, inputs', ... }:

let
  enable = config.ceirios.profiles.graphical;
in
{
  imports = [ inputs'.eiddew.homeModules.default ];

  programs.eiddew = {
    inherit enable;
  };
}
