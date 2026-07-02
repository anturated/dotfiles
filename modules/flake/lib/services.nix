{ lib }:
let
  inherit (lib.types) str;
  inherit (lib.options) mkOption mkEnableOption;

  mkServiceOption =
    name:
    {
      port ? 0,
      host ? "127.0.0.1",
      domain ? "",
      ...
    }@args:
    let
      args' = removeAttrs args [
        "port"
        "host"
        "domain"
      ];
    in
    {
      enable = mkEnableOption "${name} service";

      host = mkOption {
        type = str;
        default = host;
        description = "The host for ${name} service";
      };

      port = mkOption {
        type = lib.types.port; # keep this as lib.types to avoid name clash
        default = port;
        description = "The port for ${name} service";
      };

      domain = mkOption {
        type = str;
        default = domain;
        defaultText = "networking.domain";
        description = "Domain name for the ${name} service";
      };
    }
    // args';
in
{
  inherit mkServiceOption;
}
