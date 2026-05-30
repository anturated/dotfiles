{ ... }:

{
  security.sudo-rs = {
    enable = true;

    extraConfig = ''
      Defaults !lecture
      Defaults pwfeedback
      Defaults env_keep += "EDITOR PATH DISPLAY"
    '';
  };
}
