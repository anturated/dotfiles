{
  lib,
  config,
  pkgs,
  ...
}:

let
  inherit (config.ceirios.hardware) gpu busIds;
  inherit (lib) mkIf;

  hasBusId = busIds.discrete != null;
  pciAddr =
    let
      parts = lib.splitString ":" busIds.discrete;
    in
    "0000:${lib.fixedWidthString 2 "0" (builtins.elemAt parts 0)}"
    + ":${lib.fixedWidthString 2 "0" (builtins.elemAt parts 1)}"
    + ".${builtins.elemAt parts 2}";
in
{
  config = mkIf (gpu == "nvidia" || gpu == "nv-hybrid") {
    # enable driver
    services.xserver.videoDrivers = [ "nvidia" ];

    boot = {
      # enables the Nvidia's experimental framebuffer device
      # fix for the imaginary monitor that does not exist
      kernelParams = [
        "nvidia_drm.fbdev=1"
      ]
      # fix brightness in hybrid mode
      ++ lib.optionals (gpu == "nv-hybrid") [ "video.use_native_backlight=1" ];

      # removes hdmi audio driver
      blacklistedKernelModules = [ "snd_hda_codec_hdmi" ];

      # early load modules
      initrd.kernelModules = [
        "nvidia"
        "nvidia_modeset"
        "nvidia_uvm"
        "nvidia_drm"
      ];
    };

    ceirios.packages = {
      inherit (pkgs)
        # vulkan
        vulkan-tools
        vulkan-loader
        vulkan-validation-layers
        vulkan-extension-layer

        # libva
        libva
        libva-utils
        ;
    };

    hardware = {
      nvidia = {
        # use the latest and greatest nvidia drivers
        package = config.boot.kernelPackages.nvidiaPackages.beta;

        # fix sleep
        powerManagement.enable = true;

        # open drivers tend to get fixes quicker
        # disable on older hardware (< Turing aka 1660)
        open = true;

        # we are likely on wayland so this is useless
        nvidiaSettings = false;
      };

      graphics = {
        extraPackages = [ pkgs.nvidia-vaapi-driver ];
        extraPackages32 = [ pkgs.pkgsi686Linux.nvidia-vaapi-driver ];
      };
    };

    # pin gpu to a set path
    services.udev.extraRules = lib.mkIf hasBusId ''
      KERNEL=="card*", \
      KERNELS=="${pciAddr}", \
      SUBSYSTEM=="drm", \
      SUBSYSTEMS=="pci", \
      SYMLINK+="dri/nvidia-gpu"
    '';
  };
}
