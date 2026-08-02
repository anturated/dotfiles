{ config, ... }:

{
  # enable non-free firmware
  hardware.enableRedistributableFirmware = true;

  # firmware updater for machine hardware
  services.fwupd = {
    # just assume non-graphical systems don't require fw updates
    inherit (config.ceirios.profiles.graphical) enable;
    daemonSettings.EspLocation = config.boot.loader.efi.efiSysMountPoint;
  };
}
