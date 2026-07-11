{
  lib,
  pkgs,
  config,
  ...
}:

let
  inherit (lib.modules) mkIf;
  inherit (config.ceirios.profiles) gaming;
in
{
  ceirios.packages = mkIf gaming.enable {
    inherit (pkgs) gpu-screen-recorder-gtk;
  };
}
