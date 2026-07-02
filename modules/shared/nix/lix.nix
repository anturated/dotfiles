{
  lib,
  pkgs,
  config,
  ...
}:

let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.ceirios.system.lix;
in
{
  # import per os type,
  # enable per system
  options.ceirios.system.lix = {
    enable = mkEnableOption "Lix, a nix fork that may or may not be better";
  };

  config = mkIf cfg.enable {
    nix.package = pkgs.lix;
  };
}
