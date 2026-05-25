{
  lib,
  self,
  config,
  ...
}:

let
  inherit (lib.modules) mkIf;
  inherit (self.lib) mkServiceOption;

  cfg = config.ceirios.services.anubis;
in
{
  options.ceirios.services.anubis = mkServiceOption "anubis" { };

  config = mkIf cfg.enable {
    # allow using ports
    users.users.nginx.extraGroups = [
      config.users.groups.anubis.name
    ];
  };
}
