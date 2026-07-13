{
  config,
  lib,
  ...
}:

let
  inherit (lib.options) mkOption mkEnableOption;
  inherit (lib.attrsets) attrNames;
  inherit (lib.lists) length elemAt;
  inherit (lib.types)
    submodule
    enum
    attrsOf
    str
    nullOr
    listOf
    anything
    ;

  inherit (config.ceirios) system users;
  usernames = attrNames users;
in
{
  config.assertions = [
    {
      assertion = length usernames > 1 -> system.mainUser != null;
      message = "You have multiple users configured. Please set ceirios.system.mainUser=\"yourname\"";
    }
  ];

  options.ceirios = {
    system = {
      mainUser = mkOption {
        type = nullOr (enum usernames);
        default = if (length usernames == 1) then elemAt usernames 0 else null;
        description = ''
          Main user's username. Used for root password.
          Don't need to set if there's only one user on the system.
        '';
      };
    };

    users = mkOption {
      description = "Set of users present on a given machine, with per-machine options";

      example = lib.literalExpression ''
        # machines/legion/default.nix
        ceirios = {
          users.john = {
            home = "desant";
          };
        };'';

      default = { };

      type = attrsOf (
        submodule (
          { name, ... }: {
            options = {
              home = mkOption {
                type = str;
                default = name;
                description = "Which home config to use from home/";
                example = "desant";
              };

              # here because ssh keys don't appear out of thin air
              secrets = {
                wakatime =
                  mkEnableOption ''
                    wakatime config file.
                    You must have a wakatime config file in your secrets for this to work''
                  // {
                    example = lib.literalExpression ''
                      # in secrets/<you>.yaml
                      # wakatime: |
                      #   [settings]
                      #   api_key = waka_your-wakatime-api-key-xyz'';
                  };
              };
            };
          }
        )
      );
    };

    allUsers = mkOption {
      description = "Set of all possible users across this flake.";
      default = { };

      example = lib.literalExpression ''
        ceirios.allUsers.desant = {
          hashedPassword = "$y$j9T$gV...";
        };'';

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
                  Otherwise defaults to attrName.
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
                  description = "Public keys that are allowed to ssh into this user.";
                  example = lib.literalExpression ''
                    ssh.authorizedKeys = [
                      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMOJoauZQLAdUyxVmB+oxNQK+LSQ1Y3/L///GjC+oQlG"
                    ];'';
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
                  example = lib.literalExpression ''
                    # this would let you `ssh my-vps` instead of `ssh john@82.38.x.xx`
                    ssh.settings = {
                      "my-vps" = {
                        user = "john";
                        hostname = "82.38.x.xx";
                      };
                    };'';
                };
              };

              git = {
                name = mkOption {
                  type = nullOr str;
                  default = null;
                  description = "Username shown in git commits. Usually your github handle.";
                };

                email = mkOption {
                  type = nullOr str;
                  default = null;
                  description = "Email shown in git commits. Usually your github login email.";
                };
              };
            };
          }
        )
      );
    };
  };
}
