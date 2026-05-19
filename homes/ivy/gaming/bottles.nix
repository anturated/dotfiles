{
  config,
  lib,
  inputs',
  ...
}:

{
  ceirios.packages = lib.mkIf config.ceirios.profiles.gaming {
    # using stable here because openldap won't pass tests
    inherit (inputs'.nixpkgs-stable.legacyPackages) bottles;
  };
}
