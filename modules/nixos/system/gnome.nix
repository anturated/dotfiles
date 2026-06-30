{
  lib,
  pkgs,
  config,
  ...
}:

let
  inherit (lib) mkIf mkForce;
  inherit (config.ceirios.profiles) graphical;
in
{
  config = mkIf graphical.enable {
    services = {
      udev.packages = [ pkgs.gnome-settings-daemon ];

      gnome = {
        glib-networking.enable = true;

        # save secrets
        gnome-keyring.enable = true;

        # since https://github.com/NixOS/nixpkgs/pull/379731
        # was merged, gcr-ssh-agent is enabled by ggnome-keyring.enable
        # but i don't want it on beacuse i configure my gpg agent through home-manager
        gcr-ssh-agent.enable = false;

        # I don't need remote desktop
        gnome-remote-desktop.enable = mkForce false;
      };
    };
  };
}
