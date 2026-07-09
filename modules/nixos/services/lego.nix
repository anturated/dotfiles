{
  config,
  lib,
  self,
  ...
}:

let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkOption;
  inherit (lib.attrsets) concatMapAttrs;
  inherit (lib.types)
    str
    nullOr
    attrsOf
    submodule
    anything
    ;

  inherit (self.lib) mkSecret;
  inherit (config.sops) secrets;

  # they all need different var names so i'd rather be explicit
  providerCreds = {
    porkbun = {
      PORKBUN_API_KEY_FILE = secrets.lego-porkbun-key.path;
      PORKBUN_SECRET_API_KEY_FILE = secrets.lego-porkbun-secret.path;
    };
  };

  # i love automating things i could've defined once
  mkEntry = provider: type: {
    "lego-${provider}-${type}" = mkSecret {
      file = "lego";
      key = "${provider}-${type}";
      owner = "acme";
      group = "acme";
    };
  };

  mkLegoSecrets = concatMapAttrs (
    provider: _: (mkEntry provider "key") // (mkEntry provider "secret")
  ) providerCreds;
in
{
  options.security.acme.certs = mkOption {
    type = attrsOf (
      submodule (
        { config, ... }:
        {
          freeformType = attrsOf anything;

          options.autoProvider = mkOption {
            type = nullOr str;
            default = "porkbun";
            description = "Put your provider here to automatically load secrets for it";
          };

          config = mkIf (config.autoProvider != null) {
            dnsProvider = config.autoProvider;
            credentialFiles =
              providerCreds.${config.autoProvider}
                or (throw "Auto creds not configured for ${config.autoProvider}");
            webroot = null;
          };
        }
      )
    );
  };

  config = mkIf config.ceirios.services.nginx.enable {
    security.acme = {
      acceptTerms = true;
      defaults.email = "desant" + "@" + "anturated" + "." + "dev";
    };

    sops.secrets = mkLegoSecrets;
  };
}
