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
      {
        "255.255.255.255" = 32;
        "255.255.255.254" = 31;
        "255.255.255.252" = 30;
        "255.255.255.248" = 29;
        "255.255.255.240" = 28;
        "255.255.255.224" = 27;
        "255.255.255.192" = 26;
        "255.255.255.128" = 25;
        "255.255.255.0" = 24;
        "255.255.254.0" = 23;
        "255.255.252.0" = 22;
        "255.255.248.0" = 21;
        "255.255.240.0" = 20;
        "255.255.224.0" = 19;
        "255.255.192.0" = 18;
        "255.255.128.0" = 17;
        "255.255.0.0" = 16;
        "255.254.0.0" = 15;
        "255.252.0.0" = 14;
        "255.248.0.0" = 13;
        "255.240.0.0" = 12;
        "255.224.0.0" = 11;
        "255.192.0.0" = 10;
        "255.128.0.0" = 9;
        "255.0.0.0" = 8;
        "254.0.0.0" = 7;
        "252.0.0.0" = 6;
        "248.0.0.0" = 5;
        "240.0.0.0" = 4;
        "224.0.0.0" = 3;
        "192.0.0.0" = 2;
        "128.0.0.0" = 1;
      }
      .${netmask} or null;

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
          routes = optionals (cfg.gateway != null) [
            {
              address = cfg.gateway;
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
          routes = optionals (cfg.gateway6 != null) [
            {
              address = cfg.gateway6;
              prefixLength = cfg.prefix6;
            }
          ];
        };
      };
    };
  };
}
