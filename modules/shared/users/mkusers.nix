{
  lib,
  _class,
  config,
  ...
}:

let
  inherit (lib)
    mergeAttrsList
    optionalAttrs
    genAttrs
    mkDefault
    ;
in
{
  users.users = genAttrs (builtins.attrNames config.ceirios.users) (
    name:
    let
      inherit (config.home-manager.users.${name}.ceirios.software.defaults) shell;
      inherit (config.ceirios.allUsers.${name}) ssh hashedPassword;
    in
    mergeAttrsList [
      # set shell
      { shell = "/run/current-system/sw/bin/${shell}"; }

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
          "cloudflared"
        ];
      })
    ]
  );
}
