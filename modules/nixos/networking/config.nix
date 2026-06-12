# this abomination of a file exists
# to help set up VPS with DHCP problems
{ config, lib, ... }:

let
  inherit (lib)
    mkIf
    mkOption
    mkForce
    optionals
    ;
  inherit (lib.types) nullOr str int;

  maskToPrefix =
    netmask:
    if (netmask == null) then
      null
    else
      let
        octets = lib.splitString "." netmask;
        countBits =
          octet:
          let
            n = lib.toInt octet;
            go = acc: x: if x == 0 then acc else go (acc + (lib.mod x 2)) (x / 2);
          in
          go 0 n;
      in
      if builtins.length octets != 4 then null else lib.foldl' (acc: o: acc + countBits o) 0 octets;

  cfg = config.ceirios.networking;
in
{
  options.ceirios.networking = {
    ip = mkOption {
      type = nullOr str;
      default = null;
      description = "Your ipv4 address";
    };
    ip6 = mkOption {
      type = nullOr str;
      default = null;
      description = "Your ipv6 address";
    };

    gateway = mkOption {
      type = nullOr str;
      default = null;
      description = "Your ipv4 gateway";
    };
    gateway6 = mkOption {
      type = nullOr str;
      default = null;
      description = "Your ipv6 gateway";
    };

    netmask = mkOption {
      type = nullOr str;
      default = null;
      description = "Your netmask";
    };
    prefix = mkOption {
      type = nullOr int;
      default = maskToPrefix cfg.netmask;
      description = "Your prefix. Set netmask to auto-generate.";
    };

    netmask6 = mkOption {
      type = nullOr str;
      default = null;
      description = "Your netmask v6";
    };
    prefix6 = mkOption {
      type = nullOr int;
      default = null;
      description = "Your prefix v6";
    };

    interface = mkOption {
      type = nullOr str;
      default = null;
      description = "Your interface name";
    };
  };

  config.networking = mkIf (cfg.interface != null) {
    defaultGateway = mkIf (cfg.gateway != null) {
      address = cfg.gateway;
      inherit (cfg) interface;
    };

    defaultGateway6 = mkIf (cfg.gateway6 != null) {
      address = cfg.gateway6;
      inherit (cfg) interface;
    };

    dhcpcd.enable = mkForce false;

    interfaces = {
      ${cfg.interface} = {
        ipv4 = mkIf (cfg.prefix != null) {
          addresses = optionals (cfg.ip != null) [
            {
              address = cfg.ip;
              prefixLength = cfg.prefix;
            }
          ];
        };
        ipv6 = mkIf (cfg.prefix6 != null) {
          addresses = optionals (cfg.ip6 != null) [
            {
              address = cfg.ip6;
              prefixLength = cfg.prefix6;
            }
          ];
        };
      };
    };
  };
}
