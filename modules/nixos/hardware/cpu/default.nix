{ lib, ... }:

let
  inherit (lib.options) mkOption mkEnableOption;
  inherit (lib.types) nullOr enum;
in
{
  imports = [
    ./amd.nix
    ./intel.nix
  ];

  options.ceirios.hardware.cpu = mkOption {
    type = nullOr (enum [
      "intel"
      "intel-vm"
      "amd"
      "amd-vm"
    ]);
    default = null;
    description = "Your CPU vendor.";
  };

  options.ceirios.capabilities.CPPC = mkEnableOption ''
    AMD pstate optimizations.
    Set this to true if your CPU has CPPC'';
}
