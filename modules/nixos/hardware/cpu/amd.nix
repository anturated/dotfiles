{ lib, config, ... }:

let
  inherit (lib.modules) mkIf;
  inherit (lib.lists) optionals;
  inherit (lib.strings) optionalString;
  inherit (config.ceirios) hardware;
  inherit (config.ceirios.profiles) virtualisation;
in
{
  config = mkIf (hardware.cpu == "amd" || hardware.cpu == "amd-vm") {
    hardware.cpu.amd.updateMicrocode = true;

    boot = {
      kernelModules = optionals virtualisation.enable [ "kvm-amd" ];
      extraModprobeConfig = optionalString virtualisation.enable "options kvm_amd nested=1";
    };
  };
}
