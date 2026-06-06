{
  lib,
  pkgs,
  config,
  ...
}:

let
  cfg = config.ceirios.system.lix;
in
{
  # import per os type,
  # enable per system
  options.ceirios.system.lix = {
    enable = lib.mkEnableOption "Enable Lix";
  };

  config = lib.mkIf cfg.enable {
    nix.package = pkgs.lix;
  };
}
