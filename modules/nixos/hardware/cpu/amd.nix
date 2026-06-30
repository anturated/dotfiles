{ lib, config, ... }:

let
  inherit (lib) mkIf optionals;
  inherit (config.ceirios) hardware;
  inherit (config.ceirios.profiles) virtualization;
in
{
  config = mkIf (hardware.cpu == "amd" || hardware.cpu == "amd-vm") {
    hardware.cpu.amd.updateMicrocode = true;

    boot.kernelModules = optionals virtualization.enable [ "kvm-amd" ];
  };
}
