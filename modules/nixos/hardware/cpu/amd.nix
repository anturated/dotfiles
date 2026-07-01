{ lib, config, ... }:

let
  inherit (lib) mkIf optionals;
  inherit (config.ceirios) hardware;
  inherit (config.ceirios.profiles) virtualisation;
in
{
  config = mkIf (hardware.cpu == "amd" || hardware.cpu == "amd-vm") {
    hardware.cpu.amd.updateMicrocode = true;

    boot.kernelModules = optionals virtualisation.enable [ "kvm-amd" ];
    boot.extraModprobeConfig = optionals virtualisation.enable "options kvm_amd nested=1";
  };
}
