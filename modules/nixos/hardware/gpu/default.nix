{ lib, ... }:

let
  inherit (lib.options) mkOption;
  inherit (lib.types) nullOr enum str;
in
{
  imports = [
    ./amd.nix
    ./intel.nix
    ./nvidia.nix
    ./prime.nix
  ];

  options.ceirios.hardware = {
    gpu = mkOption {
      type = nullOr (enum [
        "amd"
        "intel"
        "nvidia"
        "nv-hybrid"
      ]);
      default = null;
      description = ''
        Your GPU vendor.
        Use nv-hybrid if you have a igpu + nvidia dgpu hybrid mode enabled in BIOS.
      '';
    };

    busIds = {
      primary = mkOption {
        type = nullOr str;
        default = null;
        description = ''
          Primary/iGPU bus id.
          Required for PRIME offload.
          Renders everything but games in offload mode.
        '';
        example = "6:0:0";
      };
      discrete = mkOption {
        type = nullOr str;
        default = null;
        description = ''
          Nvidia/dGPU bus id.
          Required for prime.
          Renders games in offload mode.
          You want to set this and primary if your second monitor port is wired to NVIDIA GPU.
          If you use a second monitor that is.
        '';
        example = "1:0:0";
      };
    };

    prime = mkOption {
      type = nullOr (enum [
        "sync"
        "reverse-sync"
        "offload"
      ]);
      default = null;
      description = ''
        Nvidia PRIME mode.
        https://wiki.nixos.org/wiki/NVIDIA#Hybrid_graphics_with_PRIME
      '';
    };
  };
}
