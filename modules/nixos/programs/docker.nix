{ lib, config, ... }:

let
  inherit (config.ceirios.profiles) workstation headless;
  cond = workstation.enable || headless.enable;
in
{
  config = lib.mkIf cond {
    virtualisation.docker.enable = true;
    systemd.services.docker.wantedBy = lib.mkForce [ ]; # Don't start on boot
    systemd.sockets.docker.wantedBy = [ "sockets.target" ]; # Start the socket instead
  };
}
