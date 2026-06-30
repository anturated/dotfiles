{
  pkgs,
  config,
  lib,
  ...
}:

let
  inherit (lib.modules) mkIf;
  inherit (config.ceirios.profiles) graphical;
in
{
  fonts = mkIf graphical.enable {
    enableDefaultPackages = true;

    packages = with pkgs; [
      corefonts

      # idk if this is necessary #
      source-sans
      source-serif

      dejavu_fonts
      inter

      noto-fonts

      # symbols #
      nerd-fonts.symbols-only
      material-symbols

      # non-latin #
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif

      # emoji #
      twemoji-color-font
      noto-fonts-color-emoji
    ];
  };
}
