{ lib, ... }:

{
  security.sudo-rs = {
    enable = true;

    # UHHHH I DON'T LIKE THIS BUT WE'LL SEE HOW IT GOES
    # this is here because password on rebuild and deploy is annoying

    # disable sudo password prompt for wheel on trusted binaries
    wheelNeedsPassword = lib.mkDefault false;
    execWheelOnly = true;

    # disable the here be dragons message
    # display '*' when entering password
    # keep some env stuff
    extraConfig = ''
      Defaults !lecture
      Defaults pwfeedback
      Defaults env_keep += "EDITOR PATH DISPLAY"
    '';
  };
}
