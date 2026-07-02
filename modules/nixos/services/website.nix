{
  lib,
  config,
  self,
  inputs,
  ...
}:

let
  inherit (lib.modules) mkIf;
  inherit (self.lib) mkServiceOption mkSecret;
  inherit (config.sops) secrets;

  cfg = config.ceirios.services.anturated-website;
in
{
  imports = [ inputs.anturated-website.nixosModules.default ];

  options.ceirios.services.anturated-website = mkServiceOption "anturated-website" {
    inherit (config.networking) domain;
    port = 3000;
  };

  config = mkIf cfg.enable {
    services.anturated-website = {
      enable = true;
      env = secrets.website-env.path;
    };

    services.nginx.virtualHosts.${cfg.domain} = {
      serverAliases = [ "www.${cfg.domain}" ];
      enableACME = true;
      locations."/" = {
        proxyPass = "http://${cfg.host}:${toString cfg.port}";
      };
    };

    sops.secrets.website-env = mkSecret {
      key = "env";
      file = "website";
    };
  };
}
