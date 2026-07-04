{
  lib,
  _class,
  config,
  pkgs,
  ...
}:

let
  inherit (lib.attrsets)
    mergeAttrsList
    optionalAttrs
    genAttrs
    attrNames
    ;
  inherit (lib.modules) mkDefault;
in
{
  users.users = genAttrs (attrNames config.ceirios.users) (
    name:
    let
      inherit (config.home-manager.users.${name}.ceirios.programs.defaults) shell;
      inherit (config.ceirios.allUsers.${name}) ssh hashedPassword;

      shellPkg =
        {
          fish = pkgs.fish;
          zsh = pkgs.zsh;
        }
        .${shell} or pkgs.bashInteractive;
    in
    mergeAttrsList [
      # set shell
      { shell = shellPkg; }

      # darwin manages users differently so we just point at home
      (optionalAttrs (_class == "darwin") { home = "/Users/${name}"; })

      # nixos allows granual control so we do that
      (optionalAttrs (_class == "nixos") {
        home = "/home/${name}";

        # set password
        inherit hashedPassword;

        # set authorized keys
        openssh.authorizedKeys.keys = ssh.authorizedKeys;

        # set some properties
        uid = mkDefault 1000;
        isNormalUser = true;

        # add groups
        extraGroups = [
          "wheel"
          "nix"
          "network"
          "networkmanager"
          "systemd-journal"
          "audio"
          "pipewire" # this gives us access to the rt limits
          "video"
          "input"
          "plugdev"
          "lp"
          "tss"
          "power"
          "wireshark"
          "mysql"
          "docker"
          "podman"
          "git"
          "libvirtd"
          "kvm"
          "cloudflared"
        ];
      })
    ]
  );
}
