{
  lib,
  self,
  _class,
  config,
  ...
}:
let
  inherit (lib.options) mkOption;

  cfg = config.ceirios.system;
in
{
  options.ceirios.system.stateVersion = mkOption {
    internal = true;
    type = lib.types.str;
    default = "25.11";
  };

  config.system = {
    # used by nixos for keeping breaking nixos changes at bay
    # should be whatever version was first installed
    stateVersion = if (_class == "nixos") then cfg.stateVersion else 6;

    # we can get the git rev that we are working on and set that to the configurationRevision
    # this *might* be useful for debugging
    configurationRevision = self.shortRev or self.dirtyShortRev or "dirty";
  };
}
