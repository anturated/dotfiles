{
  pkgs,
  lib,
  osConfig,
  ...
}:

let
  inherit (lib) optionalAttrs;
  inherit (osConfig.ceirios.hardware) gpu bluetooth;
in
{
  ceirios.packages = {
    inherit (pkgs)
      # these are just nice to have
      yazi
      btop
      gdu
      ;
  }
  // optionalAttrs bluetooth.enable {
    inherit (pkgs) bluetui;
  }
  // optionalAttrs (gpu != null) {
    nvtop = pkgs.nvtopPackages.full;
  };
}
