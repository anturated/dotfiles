{ lib, ... }:

let
  inherit (lib) mkEnableOption;
in
{
  options.ceirios.profiles = {
    graphical = mkEnableOption ''
      Enable graphical applications (hyprland, browser, terminal, etc.)
    '';

    headless = mkEnableOption ''
      Indicate that this is a server and optimize accordingly.
    '';

    workstation = mkEnableOption ''
      Enable coding stuff (ssh, docker, direnv, etc.)
    '';

    gaming = mkEnableOption ''
      Enable gaming apps (prism, steam, bottles, etc.)
    '';

    laptop = mkEnableOption ''
      Optimize for laptop (tuned, acpid, etc.)
    '';

    # TODO: this does nothing currently (i think)
    virtualization = mkEnableOption ''
      Optimize for VM hosting (iommu, kvm, etc.);
    '';
  };
}
