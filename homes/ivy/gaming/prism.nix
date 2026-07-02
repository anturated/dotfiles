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
      prismlauncher = pkgs.prismlauncher.override {
        # Add binary required by some mod
        additionalPrograms = [ pkgs.ffmpeg ];

        # Change Java runtimes available to Prism Launcher
        jdks = [
          # graalvm-ce
          pkgs.graalvmPackages.graalvm-ce
          pkgs.zulu8
          pkgs.zulu17
          pkgs.zulu
        ];
      };
    };

    # audio fix
    home.file.".alsoftrc".text = "drivers=pulse";
  };
}
