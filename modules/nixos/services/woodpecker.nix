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
  webuiAddr = "${cfg.host}:${toString cfg.port}";
  serverAddr = "${cfg.host}:${toString cfg.portGRPC}";
  healthAddr = "${cfg.host}:${toString cfg.portHealthcheck}";

  inherit (lib) mkIf mkOption mapAttrs';
  inherit (self.lib) mkServiceOption mkSecret;
  inherit (config.sops) secrets;
  inherit (config.ceirios.services) forgejo;
in
{
  options.ceirios.services.woodpecker = mkServiceOption "Woodpecker CI" {
    domain = "ci.${rdomain}";
    port = 8000; # webui

    portGRPC = mkOption {
      type = lib.types.int;
      default = 9000;
      description = "Agent comms port";
    };

    portHealthcheck = mkOption {
      type = lib.types.int;
      default = 3001;
      description = "Healthcheck port";
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
          WOODPECKER_SERVER_ADDR = webuiAddr;
          WOODPECKER_GRPC_ADDR = serverAddr;
          WOODPECKER_OPEN = "true"; # you can only register with forgejo and that's closed
          WOODPECKER_ADMIN = "anturated";
          WOODPECKER_FORGEJO = "true";
          WOODPECKER_FORGEJO_URL = "https://${forgejo.domain}";
          WOODPECKER_DATABASE_DRIVER = "postgres";
          WOODPECKER_DATABASE_DATASOURCE = "postgres:///${dbUser}?host=/run/postgresql";
        };
      };

      woodpecker-agents.agents."morthwyl" = {
        enable = true;
        environmentFile = [ secrets.woodpecker-secret.path ];
        environment = {
          WOODPECKER_SERVER = serverAddr;
          WOODPECKER_MAX_WORKFLOWS = "4";
          WOODPECKER_BACKEND = "docker";
          WOODPECKER_HEALTHCHECK_ADDR = healthAddr;
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
          proxyPass = "http://${webuiAddr}";
        };
      };
    };

    sops.secrets = {
      # site admin -> apps -> create one, get secrets -> profit
      # WOODPECKER_FORGEJO_CLIENT WOODPECKER_FORGEJO_SECRET
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
