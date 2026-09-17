{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (config.ceirios.profiles) virtualisation;
  inherit (lib.modules) mkIf;
in
{
  config = mkIf virtualisation.enable {
    virtualisation.libvirtd = {
      enable = true;

      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        # swtpm.enable = true; # TPM emulation
      };
    };

    programs.virt-manager.enable = true;

    # socket exists for this, give me my boot time back
    systemd.services.libvirtd.wantedBy = lib.mkForce [ ];
  };
}
