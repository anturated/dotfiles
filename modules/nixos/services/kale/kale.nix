{
  pkgs,
  config,
  lib,
  ...
}:

let
  inherit (lib.modules) mkIf;
  inherit (lib.lists) elem;
  inherit (config.ceirios.profiles) gaming laptop;

  bts = cond: if cond then "1" else "0";

  hasOffload = bts (config.ceirios.hardware.prime == "offload");
  hasPower = bts laptop.enable;
  hasNtsync = bts (elem "ntsync" config.boot.kernelModules);
in
{
  ceirios.packages = mkIf gaming.enable {
    kale = pkgs.writeShellApplication {
      name = "kale";

      runtimeInputs = with pkgs; [
        gamemode
        mangohud
      ];

      text = ''
        # defaults
        CEIRIOS_HAS_HYPR=1 # TODO: do this properly
        CEIRIOS_HAS_POWER=${hasPower}
        CEIRIOS_HAS_OFFLOAD=${hasOffload}
        CEIRIOS_HAS_NTSYNC=${hasNtsync}
      ''
      + builtins.readFile ./kale.sh;
    };
  };
}
