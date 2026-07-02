{
  config,
  lib,
  self,
  ...
}:

let
  inherit (lib.modules) mkIf;
  inherit (self.lib) mkServiceOption;

  cfg = config.ceirios.services.jellyfin;
  rdomain = config.networking.domain;
in
{
  options.ceirios.services.jellyfin = mkServiceOption "jellyfin" {
    domain = "fin.${rdomain}";
    port = 8096; # TODO: find a way to configure
  };

  config = mkIf cfg.enable {
    services = {
      jellyfin = {
        enable = true;
        openFirewall = false;
      };

      nginx.virtualHosts.${cfg.domain} = {
        locations."/" = {
          proxyPass = "http://${cfg.host}:${toString cfg.port}";
          proxyWebsockets = true;
        };
      };
    };
  };
}
