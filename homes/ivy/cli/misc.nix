{
  pkgs,
  lib,
  config,
  ...
}:

let
  inherit (lib) mergeAttrsList optionalAttrs;
  inherit (config.ceirios) profiles;
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

    (optionalAttrs profiles.gaming {
      inherit (pkgs)
        asdf-vm
        ;
    })

    # graphical
    (optionalAttrs profiles.graphical {
      inherit (pkgs)
        # control
        brightnessctl
        playerctl

        # clipboard
        wl-clipboard-rs
        xclip # TODO: test if proton needs this nowadays

        imagemagick # nice to have for images
        ;
    })
  ];
}
