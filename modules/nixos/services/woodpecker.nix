{
  config,
  lib,
  self,
  ...
}:

let
  cfg = config.ceirios.services.woodpecker;
  rdomain = config.networking.domain;

  # it has DynamicUser so just put this wherever
  dbUser = "woodpecker-server";

  inherit (lib) mkIf mkOption mapAttrs';
  inherit (self.lib) mkServiceOption mkSecret;
  inherit (config.sops) secrets;
  inherit (config.ceirios.services) forgejo;
in
{
  options.ceirios.services.woodpecker = mkServiceOption "Woodpecker CI" {
    domain = "ci.${rdomain}";
    port = 8000;
    portHealthcheck = mkOption {
      type = lib.types.int;
      default = 3001;
      description = "Healthcheck port to use instead of 3000";
    };
  };

  config = mkIf cfg.enable {
    services = {
      woodpecker-server = {
        enable = true;
        environmentFile = [
          secrets.woodpecker-env.path
          secrets.woodpecker-secret.path
        ];
        environment = {
          WOODPECKER_HOST = "https://${cfg.domain}";
          WOODPECKER_OPEN = "false"; # no registration
          WOODPECKER_ADMIN = "anturated";
          WOODPECKER_GITEA = "true";
          WOODPECKER_GITEA_URL = "https://${forgejo.domain}";
          WOODPECKER_DATABASE_DRIVER = "postgres";
          WOODPECKER_DATABASE_DATASOURCE = "postgres:///${dbUser}?host=/run/postgresql";
        };
      };

      woodpecker-agents.agents."morthwyl" = {
        enable = true;
        environmentFile = [ secrets.woodpecker-secret.path ];
        environment = {
          WOODPECKER_SERVER = "localhost:9000"; # idk if i can change server port
          WOODPECKER_MAX_WORKFLOWS = "4";
          WOODPECKER_BACKEND = "docker";
          WOODPECKER_HEALTHCHECK_ADDR = ":${toString cfg.portHealthcheck}";
        };
      };

      postgresql = {
        ensureDatabases = [ dbUser ];
        ensureUsers = lib.singleton {
          name = dbUser;
          ensureDBOwnership = true;
        };
      };

      nginx.virtualHosts.${cfg.domain} = {
        locations."/" = {
          proxyPass = "http://${cfg.host}:${toString cfg.port}";
        };
      };
    };

    sops.secrets = {
      # site admin -> apps -> create one, get secrets -> profit
      # WOODPECKER_GITEA_CLIENT WOODPECKER_GITEA_SECRET
      woodpecker-env = mkSecret {
        key = "env";
        file = "woodpecker";
      };

      # just the secret from above (no key), shared between agent and server
      woodpecker-secret = mkSecret {
        key = "secret";
        file = "woodpecker";
      };
    };

    # let all agents connect to docker
    systemd.services = mapAttrs' (agent: _: {
      name = "woodpecker-agent-${agent}";
      value = {
        serviceConfig.SupplementaryGroups = [ "docker" ];
      };
    }) config.services.woodpecker-agents.agents;
  };
}
