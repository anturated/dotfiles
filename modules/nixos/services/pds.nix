# honestly doing wildcard apex handles is not worth it
# i'm gonna be the only user of this and my handle is my domain
# so leave the handles at *.pds.${rdomain} until i NEED to make *.${rdomain}
{
  config,
  lib,
  self,
  ...
}:

let
  inherit (self.lib) mkServiceOption mkSecret;
  inherit (lib.modules) mkIf;
  inherit (lib.strings) concatStringsSep;
  inherit (config.sops) secrets;

  cfg = config.ceirios.services.pds;
  rdomain = config.networking.domain;
in
{
  options.ceirios.services.pds = mkServiceOption "bluesky pds" {
    domain = "pds.${rdomain}";
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
          PDS_HOSTNAME = "${cfg.domain}";
          PDS_ADMIN_EMAIL = "desant" + "@" + "anturated" + "." + "dev";

          PDS_SERVICE_HANDLE_DOMAINS = ".${cfg.domain}";

          # https://compare.hose.cam
          PDS_CRAWLERS = concatStringsSep "," [
            "https://bsky.network"
            "https://relay.cerulea.blue"
            "https://relay.fire.hose.cam"
            "https://relay2.fire.hose.cam"
            "https://relay3.fr.hose.cam"
            "https://relay.hayescmd.net"
            "https://relay.xero.systems"
            "https://relay.upcloud.world"
            "https://relay.feeds.blue"
            "https://atproto.africa"
            "https://relay.whey.party"
          ];
        };
      };

      nginx.virtualHosts.${cfg.domain} = {
        # create certs for handles
        serverAliases = [ "*.${cfg.domain}" ];

        locations."/" = {
          proxyPass = "http://${cfg.host}:${toString cfg.port}";
          proxyWebsockets = true;
        };
      };
    };

    sops.secrets.pdsEnv = mkSecret {
      file = "pds";
      owner = "pds";
      group = "pds";
    };
  };
}
