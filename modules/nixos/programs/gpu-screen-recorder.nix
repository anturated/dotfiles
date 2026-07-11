{ config, ... }:

{
  programs.gpu-screen-recorder = {
    inherit (config.ceirios.profiles.gaming) enable;
  };
}
