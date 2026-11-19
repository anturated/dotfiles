{ pkgs, ... }:

{
  home-manager.users.desant = {
    ceirios.packages = {
      inherit (pkgs) olympus;
    };
  };
}
