# keep up to date with
# https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/profiles/qemu-guest.nix

{ config, lib, ... }:

{
  config = lib.mkIf config.ceirios.profiles.qemuGuest {
    boot.initrd.availableKernelModules = [
      "virtio_net"
      "virtio_pci"
      "virtio_mmio"
      "virtio_blk"
      "virtio_scsi"
      "9p"
      "9pnet_virtio"
      "virtiofs"
    ];
    boot.initrd.kernelModules = [
      "virtio_balloon"
      "virtio_console"
      "virtio_rng"
      "virtio_gpu"
    ];
  };
}
