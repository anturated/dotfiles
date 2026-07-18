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
  inherit (lib.attrsets) mapAttrs;
  inherit (config.ceirios) users;
in
{
  home-manager = {
    verbose = true;
    useUserPackages = true;
    useGlobalPkgs = true;
    backupFileExtension = "bak";

    # generate config per user on our machine
    users = mapAttrs (name: user: {
      # with their chosen home
      imports = [ ./${user.home} ];

      # also give it the username, because.
      _module.args.user = name;
    }) users;

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
