{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib.modules) mkDefault;
in
{
  # mkDefault is here because hyprland uhhh...
  # disables it for whatever reason. # TODO: research
  xdg.portal = {
    enable = mkDefault config.ceirios.profiles.graphical.enable;

    xdgOpenUsePortal = true;

    config = {
      common = {
        default = [ "gtk" ];

        "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
      };
    };

    wlr = {
      enable = mkDefault config.ceirios.profiles.graphical.enable;
      settings = {
        screencast = {
          max_fps = 60;
          chooser_type = "simple";
          chooser_cmd = "${pkgs.slurp}/bin/slurp -f %o -or";
        };
      };
    };
  };
}
