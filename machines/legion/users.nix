{ pkgs, ... }:

{
  home-manager.users.desant = {
    ceirios.packages = {
      inherit (pkgs)
        gpu-screen-recorder-gtk
        olympus
        ;
    };
  };
}
