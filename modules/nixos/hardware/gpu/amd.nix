{
  lib,
  pkgs,
  config,
  ...
}:

let
  inherit (lib) mkIf;
  inherit (config.ceirios.hardware) cpu gpu busIds;

  useAmd = gpu == "amd" || gpu == "nv-hybrid" && cpu == "amd";
  hasBusId = useAmd && busIds.primary != null;
  pciAddr = # assuming this is only used in laptops
    let
      parts = lib.splitString ":" busIds.primary;
    in
    "0000:${lib.fixedWidthString 2 "0" (builtins.elemAt parts 0)}"
    + ":${lib.fixedWidthString 2 "0" (builtins.elemAt parts 1)}"
    + ".${builtins.elemAt parts 2}";
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
