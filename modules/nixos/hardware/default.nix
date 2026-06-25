{ ... }:

{
  imports = [
    ./cpu
    ./gpu
    ./power
    ./bluetooth.nix
    ./firmware.nix
    ./monitors.nix
    ./qemu-guest.nix
  ];
}
