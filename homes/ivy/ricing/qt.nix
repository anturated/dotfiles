{
  pkgs,
  config,
  lib,
  ...
}:

let
  inherit (lib) mkIf;
  inherit (config.ceirios.profiles) graphical;
in
{
  config = mkIf graphical.enable {
    qt = {
      enable = true;
      platformTheme.name = "qtct";
    };

    ceirios.packages = {
      inherit (pkgs)
        # these are straight up themes
        # darkly-qt5
        darkly
        ;
    };
  };
}
