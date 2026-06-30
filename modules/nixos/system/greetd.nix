{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) concatStringsSep;

  sessionData = config.services.displayManager.sessionData.desktops;
in
{
  config.services.greetd = {
    inherit (config.ceirios.profiles.graphical) enable;
    restart = true;
    useTextGreeter = true;

    settings = {
      default_session = {
        user = "greeter";
        command = concatStringsSep " " [
          "${pkgs.tuigreet}/bin/tuigreet"
          "--time" # display date & time
          "--remember" # remember last username
          "--remember-user-session" # remember user's last session
          "--asterisks" # password turns into ****
          "--sessions '${
            concatStringsSep ":" [
              "${sessionData}/share/xsessions"
              "${sessionData}/share/wayland-sessions"
            ]
          }'"
        ];
      };
    };
  };
}
