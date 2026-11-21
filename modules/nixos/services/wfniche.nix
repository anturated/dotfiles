{
  lib,
  config,
  self,
  inputs,
  ...
}:

let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkOption;
  inherit (lib.types) bool port;
  inherit (self.lib) mkServiceOption;

  cfg = config.ceirios.services.wfniche;
  api = config.services.wfniche.server;
in
{
  imports = [ inputs.wfniche.nixosModules.default ];

  options.ceirios.services.wfniche = mkServiceOption "wfniche" {
    domain = "wf.${config.networking.domain}";
    # the nextjs site
    port = 3014;

    apiPort = mkOption {
      type = port;
      default = 3015;
      description = "port of the .NET api server";
    };

    allowRegistration = mkOption {
      type = bool;
      default = true;
      description = "let anyone sign up. flip off once your account exists";
    };
  };

  config = mkIf cfg.enable {
    # local db over the unix socket with peer auth, no secrets needed
    ceirios.services.postgresql.enable = true;

    services.wfniche = {
      enable = true;
      inherit (cfg) allowRegistration;

      server = {
        inherit (cfg) host;
        port = cfg.apiPort;
      };

      web = {
        inherit (cfg) host port;
      };
    };

    services.nginx.virtualHosts.${cfg.domain} = {
      enableACME = true;

      # browser -> api directly (same origin, no hop through node)
      locations."/api/" = {
        proxyPass = "http://${api.host}:${toString api.port}";
        extraConfig = ''
          # live prices/scans are server-sent events: no buffering, no compression, long reads
          proxy_http_version 1.1;
          proxy_set_header Connection "";
          proxy_buffering off;
          proxy_cache off;
          proxy_read_timeout 1h;
          gzip off;
          brotli off;
          zstd off;

          # screenshots from the pc client
          client_max_body_size 30m;
        '';
      };

      locations."/" = {
        proxyPass = "http://${cfg.host}:${toString cfg.port}";
      };
    };
  };
}
