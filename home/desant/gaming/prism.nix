{
  pkgs,
  config,
  lib,
  ...
}:

let
  inherit (lib.modules) mkIf;
  inherit (config.ceirios.profiles) gaming;
in
{
  config = mkIf gaming.enable {
    ceirios.packages = {
      inherit (pkgs) prismlauncher;
    };

    # audio fix
    home.file.".alsoftrc".text = "drivers=pulse";
  };
}
