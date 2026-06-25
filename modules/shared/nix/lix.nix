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
    enable = lib.mkEnableOption "Lix, a nix fork that may or may not be better";
  };

  config = lib.mkIf cfg.enable {
    nix.package = pkgs.lix;
  };
}
