{ lib, _class, ... }:

let
  inherit (lib) mkEnableOption;
in
{
  options.ceirios.profiles = {
    graphical = mkEnableOption ''
      Enable graphical applications
      (hyprland, browser, terminal, etc.)'';

    headless = mkEnableOption ''
      stuff for better operation of a headless machine
      (like a VPS or WSL instance)'';

    workstation = mkEnableOption ''
      coding stuff
      (ssh, docker, direnv, etc.)'';

    gaming = mkEnableOption ''
      gaming apps and optimizations
      (prism, steam, bottles, etc.)'';

    laptop = mkEnableOption ''
      laptop optimizations and services
      (tuned, acpid, etc.)'';

    # TODO: this does nothing currently (i think)
    virtualization = mkEnableOption "stuff for VM hosting (iommu, kvm, etc.)";

    qemuGuest = mkEnableOption "QEMU guest optimizations";
  };
}
