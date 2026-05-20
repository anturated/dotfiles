{ config, lib, ... }:

let
  inherit (lib) mkIf;
in
{
  config = mkIf config.ceirios.fywion.nginx.enable {
    security.acme = {
      acceptTerms = true;
      defaults.email = "desant" + "@" + "anturated" + "." + "dev";
    };
  };
}
