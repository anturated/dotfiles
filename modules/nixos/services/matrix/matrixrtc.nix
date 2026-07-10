{
  lib,
  self,
  config,
  ...
}:

let
  inherit (lib.modules) mkIf;
  inherit (lib.lists) singleton;
  inherit (self.lib) mkServiceOption mkSecret mkPortOption;

  cfg = config.ceirios.services.matrixrtc;
in
{
  options.ceirios.services.matrixrtc = mkServiceOption "matrixrtc" {
    domain = "matrixrtc.${config.networking.domain}";
    livekitPort = mkPortOption 7880;
    livekitRtcPort = mkPortOption 7881;
    jwtPort = mkPortOption 8070;
    rtcPortMin = mkPortOption 50100;
    rtcPortMax = mkPortOption 50200;
  };

  config = mkIf cfg.enable {
    # shared secret
    # lk-jwt-service: foobar
    sops.secrets.livekit-keyfile = mkSecret {
      key = "keyfile";
      file = "livekit";
      owner = "root";
      mode = "0444"; # both livekit and lk-jwt-service services need to read it
    };

    services.livekit = {
      enable = true;
      openFirewall = true;
      keyFile = config.sops.secrets.livekit-keyfile.path;
      settings = {
        port = cfg.livekitPort;
        bind_addresses = [ cfg.host ];
        rtc = {
          tcp_port = cfg.livekitPort;
          port_range_start = cfg.rtcPortMin;
          port_range_end = cfg.rtcPortMax;
          use_external_ip = true;
        };
        turn.enabled = false;
        room.auto_create = false;
      };
    };

    services.lk-jwt-service = {
      enable = true;
      keyFile = config.sops.secrets.livekit-keyfile.path;
      livekitUrl = "wss://${cfg.domain}/livekit/sfu";
    };

    # only i get to create rooms
    systemd.services.lk-jwt-service.environment.LIVEKIT_FULL_ACCESS_HOMESERVERS =
      config.services.matrix-synapse.settings.server_name;

    services.nginx.virtualHosts.${cfg.domain} = {
      locations = {
        "/livekit/sfu" = {
          proxyPass = "http://${cfg.host}:${toString cfg.livekitPort}";
          proxyWebsockets = true;
        };
        "/livekit/jwt/" = {
          proxyPass = "http://${cfg.host}:${toString cfg.jwtPort}/";
        };
      };
    };

    # this shouldn't go through nginx
    networking.firewall = {
      allowedTCPPorts = [ 7881 ];
      allowedUDPPortRanges = singleton {
        from = cfg.rtcPortMin;
        to = cfg.rtcPortMax;
      };
    };
  };
}
