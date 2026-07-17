{
  lib,
  self,
  inputs,
  config,
  pkgs,
  ...
}:

let
  inherit (lib.modules) mkIf mkForce mkMerge;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) str;
  inherit (lib.lists) singleton;
  inherit (self.lib) mkServiceOption mkSecret;
  inherit (config.sops) secrets;

  rdomain = config.networking.domain;
  cfg = config.ceirios.services.mailserver;
in
{
  imports = [ inputs.simple-nixos-mailserver.nixosModules.default ];

  options.ceirios.services = {
    mailserver = mkServiceOption "mailserver" {
      domain = "mail.${rdomain}";

      webui = {
        enable = mkEnableOption "webui";
        domain = mkOption {
          type = str;
          default = "rc.${rdomain}";
        };
      };
    };
  };

  config = mkIf cfg.enable {
    mailserver = {
      enable = true;
      openFirewall = true;

      stateVersion = 5;

      storage = {
        directoryLayout = "fs";
        owner = "vmail";
        group = "vmail";
        path = "/srv/storage/mail/vmail";
      };

      # Enable STARTTLS
      enableImap = true;
      enableImapSsl = true;

      # eww
      enablePop3 = false;
      enablePop3Ssl = false;

      enableSubmission = false;
      enableSubmissionSsl = true;

      # Enable ManageSieve so that we don't need to change the config to update sieves
      enableManageSieve = true;

      # DKIM Settings
      dkim = {
        defaults.keyLength = 4096;
        keyDirectory = "/srv/storage/mail/dkim";
      };

      hierarchySeparator = "/";
      localDnsResolver = false;
      fqdn = cfg.domain;
      x509.useACMEHost = cfg.domain;
      domains = [ rdomain ];

      # Set all no-reply addresses
      rejectRecipients = [ "noreply@${rdomain}" ];

      accounts = {
        "desant@${rdomain}" = {
          hashedPasswordFile = config.sops.secrets.mailserver-desant.path;
          aliases = [
            "anturated@${rdomain}"
            "me@${rdomain}"
            "wlodek@${rdomain}"
            "volodymyr@${rdomain}"
            "volodymyrdesiatniuk@${rdomain}"
            "desiatniuk@${rdomain}"
            "contact@${rdomain}"
            "admin@${rdomain}"
            "root@${rdomain}"
            "postmaster@${rdomain}"
          ];
        };

        "noreply@${rdomain}" = {
          aliases = [ "noreply" ];
          hashedPasswordFile = secrets.mailserver-noreply.path;
        };

        # make it its own separate thing because theres a non-hashed version of password
        "git@${rdomain}" = {
          hashedPasswordFile = secrets.mailserver-git.path;
        };

        "spam@${rdomain}" = {
          aliases = [
            "no@${rdomain}"
            "stfu@${rdomain}"
          ];
          hashedPasswordFile = secrets.mailserver-spam.path;
        };

        "caterpillar@${rdomain}" = {
          aliases = [
            "pill@${rdomain}"
            "bot@${rdomain}"
          ];
          hashedPasswordFile = secrets.mailserver-caterpillar.path;
        };
      };

      mailboxes = {
        Archive = {
          auto = "subscribe";
          special_use = "\\Archive";
        };
        Drafts = {
          auto = "subscribe";
          special_use = "\\Drafts";
        };
        Sent = {
          auto = "subscribe";
          special_use = "\\Sent";
        };
        Junk = {
          auto = "subscribe";
          special_use = "\\Junk";
        };
        Trash = {
          auto = "subscribe";
          special_use = "\\Trash";
        };
      };

      fullTextSearch = {
        enable = true;
        # index new email as they arrive
        autoIndex = true;
        fallback = false;
      };
    };

    services = mkMerge [
      {
        postfix = {
          dnsBlacklists = [
            "all.s5h.net"
            "b.barracudacentral.org"
            "bl.spamcop.net"
            "blacklist.woody.ch"
          ];

          dnsBlacklistOverrides = ''
            ${rdomain} OK
            ${config.mailserver.fqdn} OK
            127.0.0.0/8 OK
            10.0.0.0/8 OK
            192.168.0.0/16 OK
          '';

          settings.main.smtp_helo_name = config.mailserver.fqdn;
        };

        # ssl and acme are true by default
        nginx.virtualHosts."${cfg.domain}" = { };
      }

      (mkIf cfg.webui.enable {
        roundcube = {
          enable = true;

          package = pkgs.roundcube.withPlugins (
            plugins: builtins.attrValues { inherit (plugins) persistent_login carddav; }
          );

          maxAttachmentSize = 50;

          dicts = [ pkgs.aspellDicts.en ];

          plugins = [
            "carddav"
            "persistent_login"
          ];

          hostName = "${cfg.webui.domain}";
          extraConfig = ''
            $config['imap_host'] = array(
              'ssl://${config.mailserver.fqdn}' => '@anturated.dev',
              'ssl://imap.gmail.com:993' => '@gmail.com',
            );

            $config['username_domain'] = array(
              '${config.mailserver.fqdn}' => '${rdomain}',
              'mail.gmail.com' => 'gmail.com',
            );

            $config['x_frame_options'] = false;

            # starttls needed for authentication,
            # so fqdn has to match the certificate
            $config['smtp_host'] = "ssl://${config.mailserver.fqdn}";
            $config['smtp_user'] = "%u";
            $config['smtp_pass'] = "%p";
          '';
        };

        phpfpm.pools.roundcube.settings = {
          "listen.owner" = config.services.nginx.user;
          "listen.group" = config.services.nginx.group;
        };

        postgresql = {
          ensureDatabases = [ "roundcube" ];
          ensureUsers = singleton {
            name = "roundcube";
            ensureDBOwnership = true;
          };
        };

        nginx.virtualHosts."${cfg.webui.domain}" = {
          locations."/".extraConfig = mkForce "";
        };
      })
    ];

    security.acme.certs.${cfg.domain} = {
      reloadServices = [
        "postfix.service"
        "dovecot.service"
      ];
    };

    sops.secrets = {
      mailserver-desant = mkSecret {
        key = "desant";
        file = "mailserver";
      };
      mailserver-noreply = mkSecret {
        key = "noreply";
        file = "mailserver";
      };
      mailserver-git = mkSecret {
        key = "git";
        file = "mailserver";
      };
      mailserver-spam = mkSecret {
        key = "spam";
        file = "mailserver";
      };
      mailserver-jobs = mkSecret {
        key = "jobs";
        file = "mailserver";
      };
      mailserver-caterpillar = mkSecret {
        key = "bot";
        file = "mailserver";
      };
    };
  };
}
