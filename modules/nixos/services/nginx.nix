{
  lib,
  config,
  self,
  ...
}:

let
  inherit (self.lib) mkServiceOption;
  inherit (lib.modules) mkIf mkDefault mkMerge;
  inherit (lib.options) mkOption;
  inherit (lib) types;

  cfg = config.ceirios.services.nginx;
in
{
  options = {
    ceirios.services.nginx = mkServiceOption "nginx" {
      domain = "anturated.dev";
    };

    # getchoo is cool for this
    # https://github.com/getchoo/borealis/blob/6e5ad4fb14a0de172c64e0d6a9d6f63ed7df88e6/modules/nixos/mixins/nginx.nix#L5
    services.nginx.virtualHosts = mkOption {
      type = types.attrsOf (
        types.submodule (_: {
          freeformType = types.attrsOf types.anything;

          config = {
            quic = mkDefault true;
            forceSSL = mkDefault true;
            enableACME = mkDefault true;
          };
        })
      );
    };
  };

  config = mkMerge [
    { networking = { inherit (cfg) domain; }; }

    (mkIf cfg.enable {
      users.users.nginx.extraGroups = [ "acme" ];

      networking.firewall.allowedTCPPorts = [
        80
        443
      ];

      services.nginx = {
        enable = true;
        statusPage = true; # For monitoring scraping.

        commonHttpConfig = ''
          # real_ip_header CF-Connecting-IP;
          add_header 'Referrer-Policy' 'origin-when-cross-origin';
          add_header X-Frame-Options "SAMEORIGIN" always;
          add_header X-Content-Type-Options nosniff;
        '';

        recommendedTlsSettings = true;
        recommendedBrotliSettings = true;
        recommendedOptimisation = true;
        recommendedGzipSettings = true;
        recommendedProxySettings = true;

        experimentalZstdSettings = true;

        sslCiphers = "EECDH+aRSA+AESGCM:EDH+aRSA:EECDH+aRSA:+AES256:+AES128:+SHA1:!CAMELLIA:!SEED:!3DES:!DES:!RC4:!eNULL";
        sslProtocols = "TLSv1.3 TLSv1.2";

        # undo the the changes we made to `services.nginx.virtualHosts`
        virtualHosts.localhost = {
          forceSSL = false;
          enableACME = false;
        };
      };

      # it won't pick up the right certs idk
      security.acme.certs.${cfg.domain} = {
        reloadServices = [
          "nginx.service"
        ];
      };
    })
  ];
}
