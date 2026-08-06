{ config, ... }:

let
  inherit (config.ceirios.profiles) laptop;
in
{
  networking.networkmanager = {
    enable = true;

    wifi = {
      # iwd is newer, can be wpa_supplicant too
      # note: iwd breaks for me for whatever reason
      # backend = "iwd";

      # battery
      powersave = laptop.enable;

      # randomize mac when scanning
      scanRandMacAddress = true;
    };
  };
}
