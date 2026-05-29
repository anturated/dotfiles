{ config, lib, ... }:

let
  inherit (lib)
    mkOption
    types
    ;
  inherit (types)
    submodule
    enum
    attrsOf
    str
    ;
in
{
  imports = [
    ../../../users
    ./mkusers.nix
  ];

  # this exists for per user overrides per machine
  # like home config, etc.
  options.ceirios.system = {
    mainUser = mkOption {
      type = enum (builtins.attrNames config.ceirios.system.users);
      default = builtins.elemAt (builtins.attrNames config.ceirios.system.users) 0;
      description = "Main user's username. Used for root password";
    };

    users = mkOption {
      type = attrsOf (
        submodule (
          { name, ... }:
          {
            options = {
              home = mkOption {
                type = str;
                default = "ivy";
                description = "Which home config to use from homes/";
                example = "ivy";
              };
            };
          }
        )
      );

      default = {
        desant = { };
      };
    };
  };
}
