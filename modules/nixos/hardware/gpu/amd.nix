{
  lib,
  pkgs,
  config,
  self,
  ...
}:

let
  inherit (lib.modules) mkIf;
  inherit (config.ceirios.hardware) cpu gpu busIds;

  useAmd = gpu == "amd" || gpu == "nv-hybrid" && cpu == "amd";
  hasBusId = useAmd && busIds.primary != null;
  pciAddr = self.lib.pciAddr busIds.primary;
in
{
  config = mkIf useAmd {
    # enable amdgpu xorg drivers
    services.xserver.videoDrivers = [ "amdgpu" ];

    # enable amdgpu kernel module
    boot.kernelModules = [ "amdgpu" ];

    # enables AMDVLK & OpenCL support
    hardware.graphics.extraPackages = [
      pkgs.rocmPackages.clr
      pkgs.rocmPackages.clr.icd
    ];

    # pin gpu a dir because card1 likes to jump places
    services.udev.extraRules = lib.mkIf hasBusId ''
      KERNEL=="card*", \
      KERNELS=="${pciAddr}", \
      SUBSYSTEM=="drm", \
      SUBSYSTEMS=="pci", \
      SYMLINK+="dri/amd-gpu"
    '';
  };
}
