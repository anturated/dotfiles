{ config, lib, ... }:

let
  inherit (config.ceirios.hardware)
    cpu
    gpu
    prime
    busIds
    ;
  inherit (lib.modules) mkMerge mkIf mkDefault;

  hasBusIds = busIds.primary != null && busIds.discrete != null;
  isHybrid = gpu == "nv-hybrid";
  usePrime = prime != null;
in
{
  config = mkMerge [
    # implicitly enable prime if we have hyprid mode
    (mkIf (isHybrid && hasBusIds) {
      assertions = [
        # throw an error if hybrid with no busIds
        {
          assertion = hasBusIds;
          message = "Using nv-hybrid without ceirios.hardware.busIds will likely lead to issues.";
        }
      ];
      ceirios.hardware.prime = mkDefault "offload";
    })

    (mkIf usePrime {

      assertions = [
        # panic if manually enabled and no busIds
        {
          assertion = hasBusIds;
          message = "PRIME requires both ceirios.hardware.busIds to be set";
        }
      ];

      hardware.nvidia = {
        powerManagement.finegrained = prime == "offload";
        prime = {
          amdgpuBusId = mkIf (cpu == "amd") "PCI:${busIds.primary}";
          intelBusId = mkIf (cpu == "intel") "PCI:${busIds.primary}";
          nvidiaBusId = "PCI:${busIds.discrete}";

          sync.enable = prime == "sync";
          reverseSync.enable = prime == "reverse-sync";
          offload.enable = prime == "offload";
          offload.enableOffloadCmd = prime == "offload";
        };
      };
    })
  ];
}
