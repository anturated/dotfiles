{ lib, ... }:

let
  inherit (lib)
    types
    mkOption
    ;

  inherit (types)
    str
    nullOr
    listOf
    attrsOf
    anything
    submodule
    ;
in
{
  options.ceirios.users = mkOption {
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
          };
        }
      )
    );
  };
}
