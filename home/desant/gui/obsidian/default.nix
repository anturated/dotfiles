{ config, ... }:

{
  programs.obsidian = {
    inherit (config.ceirios.profiles.graphical) enable;
    # don't think i'm gonna customize it here
    # because it gets overridden by vault's settings anyways so
  };
}
