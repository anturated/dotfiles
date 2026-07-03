{ lib, config, ... }:

let
  inherit (lib.modules) mkIf;
  inherit (config.ceirios.profiles) server;
in
{
  services.journald = {
    # persist logs
    # TODO: remove after debugging
    storage = "persistent";

    # lower logs size on non-server machines
    extraConfig = mkIf (!server.enable) ''
      SystemMaxUse=100M
      RuntimeMaxUse=50M
      SystemMaxFileSize=50M
    '';
  };
}
