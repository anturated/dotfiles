{
  lib,
  self,
  config,
  ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (lib.lists) map;
  inherit (self.lib.services) mkServiceOption;
  inherit (self.lib.secrets) mkSecret;

  rdomain = config.networking.domain;
  cfg = config.ceirios.services.gatus;

  mkEndpoints = map (
    endpoint@{
      defaultConditions ? true,
      conditions ? [ ],
      ...
    }:
    {
      interval = "5m";
      conditions = if defaultConditions then ([ "[STATUS] == 200" ] ++ conditions) else conditions;
      alerts = [ ]; # don't care for alerts rn
    }
    // (removeAttrs endpoint [
      "defaultConditions"
      "conditions"
    ])
  );
in
{

  options.ceirios.services.gatus = mkServiceOption "gatus" {
    port = 3008;
    domain = "status.${rdomain}";
  };

  config = mkIf cfg.enable {
    services = {
      gatus = {
        enable = true;

        settings = {
          web = {
            adress = cfg.host;
            inherit (cfg) port;
          };

          ui = {
            title = "anturated.dev | status";
            header = "anturated.dev | status";
            dashboard-heading = "Uptime";
            dashboard-subheading = "If any of these go down i will be sad.";
            link = "https://${cfg.domain}";
            logo = "https://anturated.dev/_next/image?url=%2Fpfp.png&w=256&q=75";
            favicon.default = "https://anturated.dev/favicon.ico";
            default-sort-by = "group";
            custom-css = ''
              :root, :root.dark {
                --background: 120 11% 7% !important;
                --foreground: 87 14% 88% !important;
                --card: 120 9% 10% !important;
                --card-foreground: 87 14% 88% !important;
                --popover: 110 10% 12% !important;
                --popover-foreground: 87 14% 88% !important;
                --primary: 119 39% 72% !important;
                --primary-foreground: 136 87% 12% !important;
                --secondary: 110 18% 75% !important;
                --secondary-foreground: 120 18% 17% !important;
                --muted: 110 10% 12% !important;
                --muted-foreground: 352 3% 56% !important;
                --accent: 110 18% 75% !important;
                --accent-foreground: 120 18% 17% !important;
                --destructive: 343 81% 75% !important;
                --destructive-foreground: 0 0% 0% !important;
                --border: 107 7% 27% !important;
                --input: 102 4% 56% !important;
                --ring: 199 76% 69% !important;
              }

              .border-gray-700 {
                border-color: #424940;
              }

              .bg-success,
              .bg-green-400, .bg-green-500, .bg-green-700 {
                background-color: #9ed49d !important;
              }
              .text-white.bg-green-400, .text-white.bg-green-500, .text-white.bg-green-700 {
                color: #043912;
              }

              .bg-red-400, .bg-red-500, .bg-red-600, .bg-red-700 {
                background-color: #ffb4ab !important;
              }
              .text-white.bg-red-400, .text-white.bg-red-500, .text-white.bg-red-600, .text-white.bg-red-700 {
                color: #690005;
              }

              .bg-yellow-400, .bg-yellow-500 {
                background-color: #d4e8d0 !important;
              }
              .text-white.bg-yellow-400, .text-white.bg-yellow-500 {
                color: #243424;
              }

              .bg-gray-200, .bg-gray-700 {
                background-color: #313630 !important;
              }

              footer, #settings {
                display: none !important;
              }
            '';
          };

          storage = {
            type = "sqlite";
            path = "/var/lib/gatus/data.db";
          };

          endpoints = mkEndpoints (import ./endpoints.nix);
        };
      };

      nginx.virtualHosts.${cfg.domain} = {
        locations."/" = {
          proxyPass = "http://${cfg.host}:${toString cfg.port}";
          proxyWebsockets = true;
        };
      };
    };

    sops.secrets.gatus-env = mkSecret {
      file = "gatus";
    };
  };
}
