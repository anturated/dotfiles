{
  lib,
  config,
  self,
  ...
}:

let
  inherit (lib.modules) mkIf;
  inherit (self.lib) mkServiceOption mkPortOption;

  rdomain = config.networking.domain;
  cfg = config.ceirios.services.adguard;

  mkFilters =
    txts:
    map (url: {
      enabled = true;
      url = url;
    }) txts;
in
{
  options.ceirios.services.adguard = mkServiceOption "adblocker dns" {
    domain = "dns.${rdomain}";
    port = 3003;

    dnsPort = mkPortOption 853;
  };

  config = mkIf cfg.enable {

    # open ports for the tls thing
    networking.firewall = {
      allowedTCPPorts = [ cfg.dnsPort ];
      allowedUDPPorts = [ cfg.dnsPort ]; # only needed for DoQ
    };

    # let adguard user read the certs
    systemd.services.adguardhome.serviceConfig.SupplementaryGroups = [ "nginx" ];

    services = {
      adguardhome = {
        inherit (cfg) enable host port;

        settings = {
          dns = {
            upstream_dns = [
              "9.9.9.9"
              "149.112.112.112"
            ];

          };

          tls = {
            enabled = true;
            server_name = cfg.domain;
            certificate_path = "/var/lib/acme/${cfg.domain}/fullchain.pem";
            private_key_path = "/var/lib/acme/${cfg.domain}/key.pem";
            port_dns_over_tls = cfg.dnsPort;
            port_dns_over_quic = cfg.dnsPort;
            port_https = 0; # disable webapi, we have nginx
          };

          filtering = {
            # what is this syntax
            protection_enabled = true;
            filtering_enabled = true;
            parental_enabled = false;

            # enforce safe search in engines
            safe_search.enabled = false;
          };

          users = [
            {
              name = "desant";
              password = "$2y$05$/c/e5qQH4b5/7zNuqbWaXe19.9u8lHdruo/191.7/tsaJlNPwg27q";
            }
          ];

          filters = mkFilters [
            # adguard stuff # https://adguardteam.github.io/HostlistsRegistry/assets/filters.json

            "https://adguardteam.github.io/HostlistsRegistry/assets/filter_1.txt" # adguard general filter
            "https://adguardteam.github.io/HostlistsRegistry/assets/filter_6.txt" # game console ads (THEY EXIST???)
            "https://adguardteam.github.io/HostlistsRegistry/assets/filter_8.txt" # List for blocking browser-based crypto mining
            "https://adguardteam.github.io/HostlistsRegistry/assets/filter_9.txt" # The Big List of Hacked Malware Web Sites
            "https://adguardteam.github.io/HostlistsRegistry/assets/filter_11.txt" # malicious urls
            "https://adguardteam.github.io/HostlistsRegistry/assets/filter_31.txt" # phone stalkerware
            "https://adguardteam.github.io/HostlistsRegistry/assets/filter_41.txt" # Poland phishing stuff
            "https://adguardteam.github.io/HostlistsRegistry/assets/filter_53.txt" # Android SDK ads
            "https://adguardteam.github.io/HostlistsRegistry/assets/filter_60.txt" # Xiaomi tracker
            "https://adguardteam.github.io/HostlistsRegistry/assets/filter_61.txt" # Smasnug tracker
            "https://adguardteam.github.io/HostlistsRegistry/assets/filter_62.txt" # Brave Ukraine psyop security
            "https://adguardteam.github.io/HostlistsRegistry/assets/filter_63.txt" # Windows/Office tracker
            "https://adguardteam.github.io/HostlistsRegistry/assets/filter_65.txt" # Vivo tracker
            "https://adguardteam.github.io/HostlistsRegistry/assets/filter_67.txt" # Apple tracker
            "https://adguardteam.github.io/HostlistsRegistry/assets/filter_66.txt" # OPPO & Realme tracker

            # stevenblack stuff #

            "https://raw.githubusercontent.com/StevenBlack/hosts/refs/heads/master/hosts"
            "https://raw.githubusercontent.com/StevenBlack/hosts/refs/heads/master/extensions/gambling/bigdargon/hosts"
            "https://raw.githubusercontent.com/StevenBlack/hosts/refs/heads/master/extensions/gambling/sinfonietta/hosts"
            "https://raw.githubusercontent.com/StevenBlack/hosts/refs/heads/master/extensions/fakenews/hosts"
          ];
        };
      };

      # free port 53
      resolved.settings.Resolve = {
        DNSStubListener = false;
      };

      nginx.virtualHosts.${cfg.domain} = {
        locations."/" = {
          proxyPass = "http://${cfg.host}:${toString cfg.port}";
          proxyWebsockets = true;
        };
      };
    };
  };
}
