{
  pkgs,
  lib,
  config,
  ...
}:

let
  inherit (config.ceirios.programs.defaults) explorer;
  inherit (config.ceirios.profiles) graphical;
  inherit (lib) mkIf;
in
{
  ceirios.packages = mkIf graphical {
    ${explorer} = pkgs.${explorer};
  };
}
