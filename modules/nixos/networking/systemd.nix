{
  # systemd DNS resolver daemon
  services.resolved.enable = true;

  systemd = {

    # don't wait for online
    network.wait-online.enable = false;

    services = {
      # don't wait for online fr
      NetworkManager-wait-online.enable = false;

      # disable networkd and resolved from being restarted on configuration changes
      # also prevents failures from services that are restarted instead of stopped
      systemd-networkd.stopIfChanged = false;
      systemd-resolved.stopIfChanged = false;
    };
  };
}
