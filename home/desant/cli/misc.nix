{
  pkgs,
  lib,
  config,
  ...
}:

let
  inherit (lib.attrsets) mergeAttrsList optionalAttrs;
  inherit (config.ceirios.profiles) graphical;
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

        nix-output-monitor # i wanna get rid of direnv autoload
        ;
    }

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
