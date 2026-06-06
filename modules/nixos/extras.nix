{ inputs, ... }:

{
  imports = [
    inputs.fywion.nixosModules.default
    inputs.home-manager.nixosModules.home-manager
  ];

  fywion.cache.enable = true;
}
