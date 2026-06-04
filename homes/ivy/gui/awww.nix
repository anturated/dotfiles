{
  pkgs,
  lib,
  config,
  ...
}:

{
  ceirios.packages = lib.mkIf config.ceirios.profiles.graphical {
    inherit (pkgs) awww;
  };

  systemd.user.services.awww-daemon = {
    Unit = {
      Description = "awww daemon";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.awww}/bin/awww-daemon";
      Restart = "on-failure";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
