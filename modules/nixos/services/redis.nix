{
  lib,
  pkgs,
  self,
  config,
  ...
}:

let
  inherit (lib.modules) mkIf mkMerge;
  inherit (self.lib) mkServiceOption;

  cfg = config.ceirios.services;
in
{
  options.ceirios.services.redis = mkServiceOption "redis" { };

  config = mkIf cfg.redis.enable {
    services.redis = {
      # use BSD licensed fork
      package = pkgs.valkey;

      servers = mkMerge [
        (mkIf cfg.forgejo.enable {
          forgejo = {
            enable = true;
            user = "forgejo";
            port = 6371;
            databases = 16;
            logLevel = "debug";
            requirePass = "forgejo";
          };
        })
      ];
    };
  };
}
