{
  config,
  lib,
  pkgs,
  ...
}:

{
  ceirios.packages = lib.mkIf config.ceirios.profiles.gaming {
    # using stable here because openldap won't pass tests
    inherit (pkgs) bottles;
  };
}
