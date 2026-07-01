{ lib, _class, ... }:

let
  inherit (lib) mkEnableOption;
in
{
  options.ceirios.profiles = {
    graphical.enable = mkEnableOption ''
      Enable graphical applications
      (hyprland, browser, terminal, etc.)'';

    headless.enable = mkEnableOption ''
      stuff for better operation of a headless machine
      (like a VPS or WSL instance)'';

    workstation.enable = mkEnableOption ''
      coding stuff
      (ssh, docker, direnv, etc.)'';

    gaming.enable = mkEnableOption ''
      gaming apps and optimizations
      (prism, steam, bottles, etc.)'';

    laptop.enable = mkEnableOption ''
      laptop optimizations and services
      (tuned, acpid, etc.)'';

    virtualisation.enable = mkEnableOption "stuff for VM hosting (iommu, kvm, etc.)";

    qemuGuest.enable = mkEnableOption "QEMU guest optimizations";
  };
}
