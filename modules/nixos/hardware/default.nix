{ ... }:

{
  imports = [
    ./cpu
    ./gpu
    ./power
    ./bluetooth.nix
    ./firmware.nix
    ./headless.nix
    ./monitors.nix
    ./qemu-guest.nix
  ];
}
