{
  lib,
  self,
  config,
  ...
}:

let
  inherit (lib.modules) mkIf;
  inherit (lib.lists) singleton;
  inherit (self.lib) mkServiceOption mkSecret mkPortOption;

  cfg = config.ceirios.services.coturn;
in
{
  options.ceirios.services.coturn = mkServiceOption "coturn" {
    domain = "turn.${config.networking.domain}";
    relayMinPort = mkPortOption 49000;
    relayMaxPort = mkPortOption 49100;
  };

  config = mkIf cfg.enable {
    sops.secrets.coturn-shared-secret = mkSecret {
      key = "turn_shared_secret";
      file = "matrix";
      owner = "turnserver";
    };

    services.coturn = {
      enable = true;
      realm = cfg.domain;
      use-auth-secret = true;
      lt-cred-mech = true;
      no-cli = true;
      min-port = cfg.relayMinPort;
      max-port = cfg.relayMaxPort;
      cert = "/var/lib/acme/${cfg.domain}/fullchain.pem";
      pkey = "/var/lib/acme/${cfg.domain}/key.pem";
      extraConfig = ''
        static-auth-secret-file=${config.sops.secrets.coturn-shared-secret.path}
      '';
    };

    # let it read the cert
    security.acme.certs.${cfg.domain} = {
      group = "turnserver";
    };

    networking.firewall = {
      allowedTCPPorts = [
        3478
        5349
      ];
      allowedUDPPorts = [
        3478
        5349
      ];
      allowedUDPPortRanges = singleton {
        from = cfg.relayMinPort;
        to = cfg.relayMaxPort;
      };
    };
  };
}
