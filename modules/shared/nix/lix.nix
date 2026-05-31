{ lib, config, ... }:

{
  # import per os type,
  # enable per system
  options.ceirios.system.lix = {
    enable = lib.mkEnableOption "Enable Lix";
  };

  config = {
    lix.enable = config.ceirios.system.lix.enable;
  };
}
