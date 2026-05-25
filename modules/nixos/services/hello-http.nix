{
  lib,
  self,
  config,
  ...
}:

let
  inherit (lib.modules) mkIf;
  inherit (self.lib) mkServiceOption;
in
{
  options.ceirios.services.hello-http = mkServiceOption "testing" { };

  config = mkIf config.ceirios.services.hello-http.enable {
    fywion.hello-http.enable = true;
  };
}
