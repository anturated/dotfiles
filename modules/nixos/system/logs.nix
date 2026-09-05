{ lib, config, ... }:

let
  inherit (lib.modules) mkIf;
  inherit (config.ceirios.profiles) server;
in
{
  services.journald = {
    # lower logs size on non-server machines
    settings.Journal = mkIf (!server.enable) {
      SystemMaxUse = "100M";
      RuntimeMaxUse = "50M";
      SystemMaxFileSize = "50M";
    };
  };
}
