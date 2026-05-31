{
  lib,
  self,
  self',
  config,
  inputs,
  inputs',
  host,
  ...
}:

let
  inherit (lib) genAttrs;
  inherit (config.ceirios.system) users;
  usernames = builtins.attrNames users;
in
{
  home-manager = {
    verbose = true;
    useUserPackages = true;
    useGlobalPkgs = true;
    backupFileExtension = "bak";

    # generate config per user on our machine
    users = genAttrs usernames (name: {
      # with their chosen home
      imports = [ ./${users.${name}.home} ];

      # also give it the username, because.
      _module.args.user = name;
    });

    extraSpecialArgs = {
      inherit
        self
        self'
        inputs
        inputs'
        host
        ;
    };

    # we should define graunteed common modules here
    sharedModules = [ (self + /modules/home-manager/default.nix) ];
  };
}
