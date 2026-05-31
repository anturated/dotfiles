{ inputs, ... }:

{
  imports = [
    inputs.fywion.nixosModules.default
    inputs.home-manager.nixosModules.home-manager
    inputs.lix-module.nixosModules.default
  ];

  fywion.cache.enable = true;
}
