{
  config,
  lib,
  ...
}:

let
  inherit (lib)
    mkOption
    mkEnableOption
    attrNames
    length
    elemAt
    ;
  inherit (lib.types)
    submodule
    enum
    attrsOf
    str
    nullOr
    listOf
    anything
    ;

  cfg = config.ceirios.system;
  systemUsers = attrNames cfg.users;
in
{
  options.ceirios = {
    system = {
      mainUser = mkOption {
        type = enum systemUsers;
        default =
          if (length systemUsers <= 1) then
            elemAt systemUsers 0
          else
            throw "You have multiple users configured. Please set ceirios.system.mainUser=\"yourname\"";
        description = "Main user's username. Used for root password";
      };

      users = mkOption {
        description = "Set of users present on a given system, with per-system options";

        default = { };

        type = attrsOf (submodule ({
          options = {
            home = mkOption {
              type = str;
              default = "ivy";
              description = "Which home config to use from homes/";
              example = "ivy";
            };
          };
        }));
      };
    };

    users = mkOption {
      description = "List of all users across this flake";
      default = { };

      type = attrsOf (
        submodule (
          { name, ... }:
          {
            options = {
              name = mkOption {
                type = str;
                default = name;
                description = ''
                  Username. Only set this if you need 2 users with the same name,
                  but different properties to use on different machines.
                  Otherwise derived from attrName.
                '';
                example = "desant";
              };

              hashedPassword = mkOption {
                type = nullOr str;
                description = ''
                  Hashed password for this user.
                  Get yours with `mkpasswd -m yescrypt`
                '';
              };

              ssh = {
                authorizedKeys = mkOption {
                  type = listOf str;
                  default = [ ];
                  description = "Keys that are allowed to ssh into this user.";
                };

                settings = mkOption {
                  type = attrsOf (
                    submodule (_: {
                      freeformType = attrsOf anything;
                    })
                  );
                  default = { };
                  description = ''
                    Shortcut for home-manager ssh.settings (~/.ssh/config).
                    You can use this to define ssh hostnames and whatnot.
                  '';
                };
              };

              secrets = {
                wakatime = mkEnableOption "Has wakatime config in secrets";
              };
            };
          }
        )
      );
    };
  };
}
