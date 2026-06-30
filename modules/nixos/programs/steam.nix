{ config, ... }:

{
  programs.steam = {
    inherit (config.ceirios.profiles.gaming) enable;

    # Open ports in the firewall for Steam Remote Play
    remotePlay.openFirewall = true;

    # Open ports in the firewall for Source Dedicated Server
    dedicatedServer.openFirewall = true;

    # Open ports in the firewall for Steam Local Network Game Transfers
    localNetworkGameTransfers.openFirewall = true;
  };
}
