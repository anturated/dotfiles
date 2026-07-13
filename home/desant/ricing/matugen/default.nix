{
  pkgs,
  lib,
  config,
  ...
}:

let
  wallpaper = ./wallpaper.webp;
in
{
  config = {
    ceirios.packages = {
      inherit (pkgs) matugen;
    };

    xdg.configFile = {
      "matugen/config.toml".source = ./config.toml;
      "matugen/templates".source = ./templates;
    };

    # bootstrap themes on first launch
    home.activation.matugenBootstrap = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      mkdir -p "$HOME/.local/share/matugen"
      SENTINEL="$HOME/.local/share/matugen/.done-${builtins.hashFile "sha256" wallpaper}"
      if [ ! -f "$SENTINEL" ]; then
        rm -f "$HOME/.local/share/matugen/.done-"*
        ${config.ceirios.packages.chwal}/bin/chwal -a "${wallpaper}"
        touch "$SENTINEL"
      fi
    '';
  };
}
