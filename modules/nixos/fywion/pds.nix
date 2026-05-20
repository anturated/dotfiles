{
  config,
  lib,
  self,
  ...
}:

let
  inherit (self.lib) mkFywionOption mkSecret;
  inherit (lib) mkIf;

  inherit (config.sops) secrets;

  cfg = config.ceirios.fywion.pds;
in
{
  options.ceirios.fywion.pds = mkFywionOption "bluesky pds" {
    inherit (config.networking) domain;
    port = 9876;
  };

  config = mkIf cfg.enable {

    sops.secrets.pdsEnv = mkSecret {
      key = "env";
      file = "pds";
      owner = "pds";
      group = "pds";
    };

    services = {
      bluesky-pds = {
        enable = true;

        environmentFiles = [ secrets.pdsEnv.path ];

        settings = {
          PDS_PORT = cfg.port;
          PDS_HOSTNAME = "pds.${cfg.domain}";
          PDS_ADMIN_EMAIL = "anturated" + "@" + "gmail" + "." + "com";
        };
      };

      nginx.virtualHosts."pds.${cfg.domain}" = {
        locations."/" = {
          proxyPass = "http://${cfg.host}:${toString cfg.port}";
          extraConfig = "proxy_buffering off;";
        };
      };
    };
  };
}
