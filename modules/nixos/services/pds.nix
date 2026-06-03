{
  config,
  lib,
  self,
  ...
}:

let
  inherit (self.lib) mkServiceOption mkSecret;
  inherit (lib) mkIf mkForce;

  inherit (config.sops) secrets;

  cfg = config.ceirios.services.pds;
in
{
  options.ceirios.services.pds = mkServiceOption "bluesky pds" {
    inherit (config.networking) domain;
    port = 9876;
  };

  config = mkIf cfg.enable {
    services = {
      bluesky-pds = {
        enable = true;

        # cli admin tool
        pdsadmin.enable = true;

        environmentFiles = [ secrets.pdsEnv.path ];

        settings = {
          PDS_PORT = cfg.port;
          PDS_HOSTNAME = "pds.${cfg.domain}";
          PDS_ADMIN_EMAIL = "desant" + "@" + "anturated" + "." + "dev";
        };
      };

      nginx.virtualHosts = {
        # main pds endpoint
        "pds.${cfg.domain}" = {
          # certs managed by acme below because wildcards
          useACMEHost = "pds.${cfg.domain}";
          enableACME = mkForce false;

          locations."/" = {
            proxyPass = "http://${cfg.host}:${toString cfg.port}";
            extraConfig = "proxy_buffering off;";
          };
        };

        # atproto stuff for domain/handle verification
        "*.pds.${cfg.domain}" = {
          # we handle this one manually because wildcards
          useACMEHost = "pds.${cfg.domain}";
          enableACME = mkForce false;

          serverName = "~^(?<user>.+).pds.${cfg.domain}$";

          # feed it atproto dids at this specific location
          locations."/.well-known/atproto-did" = {
            proxyPass = "http://${cfg.host}:${toString cfg.port}";
            extraConfig = "proxy_buffering off;";
          };
        };
      };
    };

    # manage the certs for *.pds.xxx and pds.xxx
    security.acme.certs."pds.${cfg.domain}" = {
      domain = "pds.${cfg.domain}";
      extraDomainNames = [ "*.pds.${cfg.domain}" ];
    };

    sops.secrets.pdsEnv = mkSecret {
      key = "env";
      file = "pds";
      owner = "pds";
      group = "pds";
    };
  };
}
