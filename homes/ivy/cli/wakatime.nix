{
  lib,
  config,
  osConfig,
  user,
  pkgs,
  ...
}:

let
  inherit (config.ceirios.profiles) workstation;
  inherit (config.xdg) configHome;

  hasSecret = osConfig.ceirios.users.${user}.secrets.wakatime;
in
{
  config = lib.mkIf (workstation && hasSecret) {
    ceirios.packages = {
      inherit (pkgs) wakatime-cli;
    };

    sops.secrets.wakatime = {
      path = configHome + "/wakatime/.wakatime.cfg";
    };
  };
}
