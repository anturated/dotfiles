{
  pkgs,
  config,
  lib,
  ...
}:

let
  inherit (lib.modules) mkIf;
  inherit (config.ceirios.profiles) gaming;

  pythonEnv = pkgs.python3.withPackages (
    ps: with ps; [
      dbus-python
      pygobject3
    ]
  );

  kaleDaemon = pkgs.writeTextFile {
    name = "kaled.py";
    destination = "/bin/kaled.py";
    executable = true;
    text = "#!${pythonEnv}/bin/python3\n" + builtins.readFile ./kaled.py;
  };
in
{
  config = mkIf gaming.enable {
    services.dbus.packages = [
      (pkgs.writeTextFile {
        name = "kaled-dbus-conf";
        destination = "/share/dbus-1/system.d/com.anturated.kaled.conf";
        text = ''
          <!DOCTYPE busconfig PUBLIC "-//freedesktop//DTD D-BUS Bus Configuration 1.0//EN"
          "http://www.freedesktop.org/standards/dbus/1.0/busconfig.dtd">
          <busconfig>
          <policy user="root">
          <allow own="com.anturated.kaled"/>
          </policy>
          <policy context="default">
          <allow send_destination="com.anturated.kaled"/>
          </policy>
          </busconfig>
        '';
      })
    ];

    # 2. The Background Service
    systemd.services.kaled = {
      description = "Kale Daemon";
      after = [ "dbus.service" ];
      wantedBy = [ "multi-user.target" ];
      path = [
        pkgs.hyprland
        pkgs.tuned
        pkgs.sudo
      ];
      serviceConfig = {
        ExecStart = "${kaleDaemon}/bin/kaled.py";
        Restart = "always";
      };
    };
  };
}
