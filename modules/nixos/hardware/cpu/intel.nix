{ lib, config, ... }:

let
  inherit (lib) mkIf optionals;
  inherit (config.ceirios) hardware;
  inherit (config.ceirios.profiles) virtualisation;
in
{
  config = mkIf (hardware.cpu == "intel" || hardware.cpu == "intel-vm") {
    hardware.cpu.intel.updateMicrocode = true;

    boot = {
      kernelModules = optionals virtualisation.enable [ "kvm-intel" ];
      kernelParams = [
        "i915.fastboot=1"
        "enable_gvt=1"
      ];
    };
  };
}
