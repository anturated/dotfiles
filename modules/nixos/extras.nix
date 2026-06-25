{ inputs, ... }:

{
  # NOTE TO SELF:
  # this exists because darwin needs its own import for HM
  # so until i figure out where to put this, it stays

  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];
}
