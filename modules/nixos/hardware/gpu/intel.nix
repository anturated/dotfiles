# gonna trust isabelroses on this for now
{
  lib,
  pkgs,
  config,
  ...
}:

let
  inherit (lib) mkIf attrValues;
  inherit (config.ceirios.hardware) cpu gpu busIds;

  useIntel = gpu == "intel" || gpu == "nv-hybrid" && cpu == "intel";
  hasBusId = useIntel && busIds.primary != null;
  pciAddr = # assuming this is only used in laptops
    let
      parts = lib.splitString ":" busIds.primary;
    in
    "0000:${lib.fixedWidthString 2 "0" (builtins.elemAt parts 0)}"
    + ":${lib.fixedWidthString 2 "0" (builtins.elemAt parts 1)}"
    + ".${builtins.elemAt parts 2}";
in
{
  config = mkIf useIntel {
    # we enable modesetting since this is recomeneded for intel gpus
    services.xserver.videoDrivers = [ "modesetting" ];

    # if we have a "Broadwell" or later gpu
    # we only bother installing the media driver
    # don't know what that means but aight
    hardware.graphics = {
      extraPackages = attrValues {
        inherit (pkgs) intel-media-driver intel-compute-runtime vpl-gpu-rt;
      };

      extraPackages32 = attrValues {
        inherit (pkgs.pkgsi686Linux) intel-media-driver;
      };
    };

    # pin gpu to a specific path
    services.udev.extraRules = lib.mkIf hasBusId ''
      KERNEL=="card*", \
      KERNELS=="${pciAddr}", \
      SUBSYSTEM=="drm", \
      SUBSYSTEMS=="pci", \
      SYMLINK+="dri/intel-gpu"
    '';

    # environment.variables = mkIf (config.hardware.graphics.enable && device.gpu != "hybrid-nv") {
    #   LIBVA_DRIVER_NAME = "iHD"; # prefer the modern backend
    #   VDPAU_DRIVER = "va_gl";
    # };
  };
}
