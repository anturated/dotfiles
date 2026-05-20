{
  lib,
  self,
  pkgs,
  config,
  ...
}:

let
  cfg = config.ceirios.fywion.forgejo;
  rdomain = config.networking.domain;

  evergarden-theme = pkgs.fetchurl {
    url = "https://evergarden.moe/gitea/theme-evergarden-fall-green.css";
    hash = "sha256-Jqm3Qyz/E4VecbIO2DRai8Q/tRFFW9+doKcw0Zhvf+g=";
  };

  inherit (lib.modules) mkIf mkForce;
  inherit (self.lib) mkFywionOption mkSecret;
in
{
  options.ceirios.fywion.forgejo = mkFywionOption "forgejo" {
    port = 3011;
    domain = "git.${rdomain}";
  };

  config = mkIf cfg.enable {
    sops.secrets = {
      mailserver-git-nohash = mkSecret {
        file = "mailserver";
        key = "git-nohash";
        owner = "forgejo";
        group = "forgejo";
      };

      anubis-forgejo = mkSecret {
        file = "anubis";
        key = "forgejo";
        owner = "anubis";
        group = "anubis";
      };
    };

    ceirios.fywion = {
      # turns out redis is very good for md and pfps
      # so we keep it
      redis.enable = true;
      postgresql.enable = true;
    };

    networking.firewall.allowedTCPPorts = [
      config.services.forgejo.settings.server.HTTP_PORT
      config.services.forgejo.settings.server.SSH_PORT
    ];

    services = {
      forgejo = {
        enable = true;
        package = pkgs.forgejo;
        stateDir = "/srv/storage/forgejo/data";
        lfs.enable = true;

        secrets.mailer.PASSWD = config.sops.secrets.mailserver-git-nohash.path;

        settings = {
          federation.ENABLED = true;

          server = {
            PROTOCOL = "http+unix";
            ROOT_URL = "https://${cfg.domain}";
            HTTP_PORT = cfg.port;
            DOMAIN = cfg.domain;

            # use system keys to avoid getting separate keys
            # just for forgejo
            START_SSH_SERVER = false;
            DISABLE_ROUTER_LOG = true;
            # LANDING_PAGE = "/explore/repos";

            SSH_CREATE_AUTHORIZED_KEYS_FILE = true;
            SSH_PORT = lib.head config.services.openssh.ports;

            # fix gravatar images
            OFFLINE_MODE = false;
          };

          api.ENABLE_SWAGGER = false;

          # we probably won't even see this
          DEFAULT = {
            APP_NAME = "The forge.";
            # APP_SLOGAN = "It is possible that we bent some metal here.";
          };

          attachment.ALLOWED_TYPES = "*/*";

          ui = {
            DEFAULT_THEME = "evergarden-winter-green";
            THEMES = lib.concatStringsSep "," [
              # i don't care enough to add the rest
              "evergarden-fall-green"
              # "evergarden-fall-green"
              # "evergarden-spring-green"
              # "evergarden-summer-green"

              "forgejo-auto"
              "forgejo-light"
              "forgejo-dark"
            ];
          };

          "ui.meta" = {
            AUTHOR = "Desant's forge";
            DESCRIPTION = "This is where I forge the jo";
            KEYWORDS = "git,self-hosted,gitea,forgejo,anturated,desant,open-source,nix,nixos";
          };

          actions = {
            ENABLED = false;
            DEFAULT_ACTIONS_URL = "https://code.forgejo.org";
          };

          database = {
            DB_TYPE = mkForce "postgres";
            HOST = "/run/postgresql";
            NAME = "forgejo";
            USER = "forgejo";
            PASSWD = "forgejo";
          };

          cache = {
            ENABLED = config.ceirios.fywion.redis.enable;
            ADAPTER = "redis";
            HOST = "redis://:forgejo@localhost:6371";
          };

          oauth2_client = {
            ACCOUNT_LINKING = "login";
            USERNAME = "nickname";
            ENABLE_AUTO_REGISTRATION = false;
            REGISTER_EMAIL_CONFIRM = false;
            UPDATE_AVATAR = true;
          };

          service = {
            # remove signup page, create user with
            # sudo -u forgejo forgejo admin user create \
            # --admin \
            # --username USERNAME \
            # --email EMAIL \
            # --password PASSWORD \
            # --work-path /srv/storage/forgejo/data
            # other users MAY be created on the admin panel
            # TODO: this isn't the most declarative thing ever
            DISABLE_REGISTRATION = true;
            ALLOW_ONLY_INTERNAL_REGISTRATION = true;
            # EMAIL_DOMAIN_ALLOWLIST = "anturated.dev";
            ALLOW_ONLY_EXTERNAL_REGISTRATION = false;
          };

          session = {
            COOKIE_SECURE = true;
            # i'm not logging in every week
            SESSION_LIFE_TIME = 86400 * 365;
          };

          other = {
            SHOW_FOOTER_VERSION = false;
            SHOW_FOOTER_TEMPLATE_LOAD_TIME = false;
            ENABLE_FEED = false;
          };

          migrations.ALLOWED_DOMAINS = "github.com, *.github.com, gitlab.com, *.gitlab.com";
          packages.ENABLED = false;

          repository = {
            PREFERRED_LICENSES = "MIT,GPL-3.0,GPL-2.0,LGPL-3.0,LGPL-2.1";

            # allow creating repos on push
            ENABLE_PUSH_CREATE_ORG = true;
            ENABLE_PUSH_CREATE_USER = true;
          };

          "repository.upload" = {
            FILE_MAX_SIZE = 100;
            MAX_FILES = 10;
          };

          mailer = {
            ENABLED = true;
            PROTOCOL = "smtps";
            # SMTP_ADDR = config.ceirios.fywion.mailserver.domain;
            SMTP_ADDR = "smtp.gmail.com"; # FIXME: update to own
            USER = "anturated@gmail.com";
            SMTP_PORT = 465;
          };
        };

        # backup
        dump.enable = false;
      };

      openssh.settings.UsePAM = mkForce true;

      postgresql = {
        ensureDatabases = [ "forgejo" ];
        ensureUsers = lib.singleton {
          name = "forgejo";
          ensureDBOwnership = true;
        };
      };

      anubis = mkIf config.ceirios.fywion.anubis.enable {
        instances.forgejo.settings = {
          BIND = "/run/anubis/anubis-forgejo/anubis.sock";
          METRICS_BIND = "/run/anubis/anubis-forgejo/anubis-metrics.sock";
          TARGET = "unix://${config.services.forgejo.settings.server.HTTP_ADDR}";
          ED25519_PRIVATE_KEY_HEX_FILE = config.sops.secrets.anubis-forgejo.path;
        };
      };

      nginx.virtualHosts.${cfg.domain} = {
        locations."/" = {
          recommendedProxySettings = true;
          proxyPass =
            "http://unix:"
            + (
              if config.ceirios.fywion.anubis.enable then
                config.services.anubis.instances.forgejo.settings.BIND
              else
                config.services.forgejo.settings.server.HTTP_ADDR
            );
        };
      };
    };

    # this SHOULD download the theme where it needs to be
    systemd.tmpfiles.settings."forgejo-theme" = {
      # need each dir for some reason too
      "${config.services.forgejo.stateDir}/custom/public".d = {
        mode = "0755";
        user = "forgejo";
        group = "forgejo";
      };
      "${config.services.forgejo.stateDir}/custom/public/assets".d = {
        mode = "0755";
        user = "forgejo";
        group = "forgejo";
      };
      "${config.services.forgejo.stateDir}/custom/public/assets/css".d = {
        mode = "0755";
        user = "forgejo";
        group = "forgejo";
      };

      "${config.services.forgejo.stateDir}/custom/public/assets/css/theme-evergarden-fall-green.css".C = {
        mode = "0644";
        user = "forgejo";
        group = "forgejo";
        argument = "${evergarden-theme}";
      };
    };
  };
}
