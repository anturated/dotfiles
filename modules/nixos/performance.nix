{
  lib,
  pkgs,
  config,
  ...
}:

let
  inherit (lib.modules) mkIf;

  inherit (config.ceirios.profiles) gaming;
in
{
  config = mkIf gaming.enable {
    # https://github.com/garuda-linux/garuda-nix-subsystem/blob/main/internal/modules/base/performance.nix

    # automatically tune nice levels, cachyos thing
    services.ananicy = {
      enable = true;
      package = pkgs.ananicy-cpp;
      rulesProvider = pkgs.ananicy-rules-cachyos;
    };

    # allow compressing whatever % of RAM before using swap
    # could choke the CPU a little, but should be fine
    zramSwap = {
      enable = true;
      algorithm = "zstd";
      memoryPercent = 90;
    };

    # oomd is in a different castle

    # TODO: analyze the rest
  };
}
