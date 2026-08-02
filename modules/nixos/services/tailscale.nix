{ lib, config, ... }:

let
  inherit (lib.modules) mkIf mkDefault;
  inherit (lib.options) mkEnableOption;
  inherit (config.services) tailscale;

  cfg = config.ceirios.services.tailscale;
in
{
  options.ceirios.services.tailscale = {
    enable = mkEnableOption "Tailscale Server";
  };

  config = mkIf cfg.enable {
    networking.firewall = {
      # allow tailscale traffic
      trustedInterfaces = [ "${tailscale.interfaceName}" ];
      allowedUDPPorts = [ tailscale.port ];
      checkReversePath = "loose";
    };

    services.tailscale = {
      enable = true;
      permitCertUid = "root";
      useRoutingFeatures = mkDefault "server";
      extraUpFlags = [
        "--ssh"
        "--advertise-exit-node"
      ];
    };
  };
}
