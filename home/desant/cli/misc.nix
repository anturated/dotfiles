{
  pkgs,
  lib,
  config,
  ...
}:

let
  inherit (lib.attrsets) mergeAttrsList optionalAttrs;
  inherit (config.ceirios.profiles) gaming graphical;
in
{
  ceirios.packages = mergeAttrsList [
    # just keep
    {
      inherit (pkgs)
        zip
        unzip

        # convenience
        fzf
        zoxide
        jq
        just
        killall
        rsync

        # better alternatives
        ripgrep
        eza
        bat

        # secrets
        sops
        ;
    }

    (optionalAttrs gaming.enable {
      inherit (pkgs)
        asdf-vm
        ;
    })

    # graphical
    (optionalAttrs graphical.enable {
      inherit (pkgs)
        # control
        brightnessctl
        playerctl

        # clipboard
        wl-clipboard-rs

        imagemagick # nice to have for images
        ;
    })
  ];
}
