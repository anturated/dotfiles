{
  lib,
  self,
  config,
  ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (self.lib) mkServiceOption mkSecret;

  rdomain = config.networking.domain;
  cfg = config.ceirios.services.vaultwarden;
in
{
  options.ceirios.services.vaultwarden = mkServiceOption "vaultwarden" {
    port = 3013;
    domain = "vw.${rdomain}";
  };

  config = mkIf cfg.enable {
    sops.secrets = {
      vaultwarden-env = mkSecret {
        file = "vaultwarden";
        owner = "vaultwarden";
        group = "vaultwarden";
      };
    };

    services = {
      vaultwarden = {
        enable = true;
        environmentFile = config.sops.secrets.vaultwarden-env.path;

        # https://github.com/dani-garcia/vaultwarden/blob/1.34.1/.env.template
        config = {
          DOMAIN = "https://${cfg.domain}";
          ROCKET_ADDRESS = cfg.host;
          ROCKET_PORT = cfg.port;

          SIGNUPS_ALLOWED = false;
          # SIGNUPS_DOMAINS_WHITELIST = "${rdomain}";
          SIGNUPS_VERIFY = true;
          INVITATIONS_ALLOWED = true;

          SMTP_AUTH_MECHANISM = "Login";
          SMTP_FROM = "noreply@${rdomain}";
          SMTP_FROM_NAME = "Vaultwarden";
          SMTP_HOST = config.ceirios.services.mailserver.domain;
          SMTP_PORT = 465;
          SMTP_SECURITY = "force_tls";

          SHOW_PASSWORD_HINT = false;

          LOG_LEVEL = "warn";
          EXTENDED_LOGGING = true;
          USE_SYSLOG = true;
        };
      };

      nginx.virtualHosts.${cfg.domain} = {
        locations."/" = {
          proxyPass = "http://${cfg.host}:${toString cfg.port}";
          extraConfig = "proxy_pass_header Authorization;";
          proxyWebsockets = true;
        };
      };

      postgresql = {
        ensureDatabases = [ "vaultwarden" ];
        ensureUsers = lib.singleton {
          name = "vaultwarden";
          ensureDBOwnership = true;
        };
      };
    };
  };
}
