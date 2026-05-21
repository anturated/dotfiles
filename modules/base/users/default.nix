# some stuff can be shared between darwin/iso/nixos/... and it should be here.
# like ssh keys and such.
# nixos-specific stuff like passwords is in modules/nixos/users/

{ lib, config, ... }:

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
    ./anturated.nix
    ./desant.nix
    ./mkusers.nix
    ./wizard.nix
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
