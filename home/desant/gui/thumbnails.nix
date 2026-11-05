{ pkgs, ... }:

{
  # HACK: these are for nautilus only
  # (i think.) thunar/xfce should use services.tumbler

  ceirios.packages = {
    inherit (pkgs)
      ffmpegthumbnailer # video
      webp-pixbuf-loader # webp
      libheif # heic/avif
      gdk-pixbuf # base image loaders
      ;
  };
}
