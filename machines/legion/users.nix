{ pkgs, ... }:

{
  home-manager.users.desant = {
    ceirios.packages = {
      inherit (pkgs)
        # bottles
        gpu-screen-recorder-gtk
        olympus
        ;
    };
  };
}
