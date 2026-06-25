{
  lib,
  pkgs,
  config,
  ...
}:

let
  inherit (lib.attrsets) genAttrs;
  inherit (lib.modules) mkIf;

  cfg = config.ceirios.system.security.binaries;
in
{
  options.ceirios.system.security = {
    binaries.enable = lib.mkEnableOption ''
      native binary runners (nix-ld and AppImage).
      Allows to run binaries not from nix store, like on normal linux distros.
      Usually you don't want this, you can install almost anything from nixpkgs'';
  };

  config = mkIf cfg.enable {
    ceirios.packages = { inherit (pkgs) appimage-run; };

    # run appimages with appimage-run
    boot.binfmt.registrations =
      genAttrs
        [
          "appimage"
          "AppImage"
        ]
        (ext: {
          recognitionType = "extension";
          magicOrExtension = ext;
          interpreter = "/run/current-system/sw/bin/appimage-run";
        });

    # run unpatched linux binaries with nix-ld
    programs.nix-ld = {
      enable = true;
      libraries = builtins.attrValues {
        inherit (pkgs)
          openssl
          curl
          glib
          util-linux
          glibc
          icu
          libunwind
          libuuid
          zlib
          libsecret
          # graphical
          freetype
          libglvnd
          libnotify
          sdl3
          vulkan-loader
          gdk-pixbuf
          libx11
          ;

        inherit (pkgs.stdenv.cc) cc;
      };
    };
  };
}
