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
  # mkDefault is here because hyprland has its own portal
  # and you'd rather use that over whatever 3rd party
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
