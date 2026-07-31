{
  lib,
  self,
  config,
  ...
}:

let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkOption;
  inherit (lib.types) str;
  inherit (self.lib.services) mkServiceOption;
  inherit (self.lib) mkSecret;

  rdomain = config.networking.domain;
  cfg = config.ceirios.services.wakapi;
in
{
  options.ceirios.services.wakapi = mkServiceOption "wakapi" {
    port = 3006;
    domain = "wt.${rdomain}";
    mailer = mkOption {
      type = str;
      default = "noreply@${rdomain}";
      description = "Email address for wakapi.";
    };
  };

  config = mkIf cfg.enable {
    sops.secrets.wakapi-env = mkSecret {
      file = "wakapi";
      owner = "wakapi";
      group = "wakapi";
    };

    ceirios.services = {
      postgresql.enable = true;
    };

    services = {
      wakapi = {
        enable = true;
        environmentFiles = [ config.sops.secrets.wakapi-env.path ];

        # setup postgresql database
        database.createLocally = true;

        settings = {
          # HACK: from what i understand this is the only way we get an avatar
          app.avatar_url_template = "https://anturated.dev/_next/image?url=%2Fpfp.png&w=256&q=75";

          server = {
            inherit (cfg) port;
            public_url = "https://${cfg.domain}";
          };

          db = {
            dialect = "postgres";
            host = "/run/postgresql";
            port = 5432; # needs to be set
            name = "wakapi";
            user = "wakapi";
          };

          security = {
            allow_signup = false;
            disable_frontpage = true;
          };

          mail = {
            enabled = true;
            sender = "<${cfg.mailer}>";
            provider = "smtp";
            smtp = {
              host = "mail.${rdomain}";
              port = 465;
              username = cfg.mailer;
              tls = true;
            };
          };
        };
      };

      postgresql = {
        ensureDatabases = [ "wakapi" ];
        ensureUsers = lib.singleton {
          name = "wakapi";
          ensureDBOwnership = true;
        };
      };

      nginx.virtualHosts.${cfg.domain} = {
        locations."/" = {
          proxyPass = "http://${cfg.host}:${toString cfg.port}";
        };
      };
    };
  };
}
