{ pkgs, ... }:

{
  services.usbmuxd = {
    enable = true;
  };

  ceirios.packages = {
    inherit (pkgs) libimobiledevice;
  };
}
