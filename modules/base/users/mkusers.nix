{
  lib,
  self,
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
  inherit (self.lib) ifTheyExist;
in
{
  users.users = genAttrs (builtins.attrNames config.ceirios.system.users) (
    name:
    let
      inherit (config.home-manager.users.${name}.ceirios.software.defaults) shell;
      inherit (config.ceirios.users.${name}) ssh hashedPassword;
    in
    mergeAttrsList [
      {
        shell = "/run/current-system/sw/bin/${shell}";
      }

      (optionalAttrs (_class == "darwin") {
        home = "/Users/${name}";
      })

      (optionalAttrs (_class == "nixos") {
        home = "/home/${name}";

        inherit hashedPassword;
        openssh.authorizedKeys.keys = ssh.authorizedKeys;

        uid = mkDefault 1000;
        isNormalUser = true;

        # only add groups that exist
        extraGroups = [
          "wheel"
          "nix"
        ]
        ++ ifTheyExist config [
          "network"
          "networkmanager"
          "systemd-journal"
          "audio"
          "pipewire" # this give us access to the rt limits
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
