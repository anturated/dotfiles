{ lib, config, ... }:

let
  inherit (lib.modules) mkIf mkMerge;
in
{
  systemd = mkMerge [
    {
      # ensure that the scripts are good at build time
      enableStrictShellChecks = true;
    }

    # limit all the (1m 30s) service timeouts to 15s on graphical systems
    (mkIf config.ceirios.profiles.graphical.enable {
      settings.Manager = {
        DefaultTimeoutStartSec = "15s";
        DefaultTimeoutStopSec = "15s";
        DefaultTimeoutAbortSec = "15s";
        DefaultDeviceTimeoutSec = "15s";
      };

      user.settings.Manager = {
        DefaultTimeoutStartSec = "15s";
        DefaultTimeoutStopSec = "15s";
        DefaultTimeoutAbortSec = "15s";
        DefaultDeviceTimeoutSec = "15s";
      };
    })
  ];
}
