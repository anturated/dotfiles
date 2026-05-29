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
        # i don't know every command yet
        zip
        unzip
        killall

        # convenience
        fzf
        zoxide
        jq
        just

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
        xclip # NOTE: remove when proton wayland is a thing

        imagemagick # FIXME: since this is for wallpapers maybe move it to the script
        ;
    })
  ];
}
