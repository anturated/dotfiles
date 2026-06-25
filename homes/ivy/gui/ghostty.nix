{ config, ... }:

{
  programs.ghostty = {
    enable =
      config.ceirios.profiles.graphical && (config.ceirios.programs.defaults.terminal == "ghostty");
    settings = {
      theme = "matugen";

      cursor-style = "underline";
      cursor-style-blink = false;

      window-width = 65;
      window-height = 17;
      confirm-close-surface = false;

      background-opacity = "0.9";

      font-family = config.ceirios.style.fonts.name;
      font-size = config.ceirios.style.fonts.size;
      font-family-bold = config.ceirios.style.fonts.bold;
      font-family-italic = config.ceirios.style.fonts.italic;
      font-family-bold-italic = config.ceirios.style.fonts.bold-italic;

      working-directory = "home";

      # need this to apply --class
      gtk-single-instance = false;

      # home-manager does this for us
      shell-integration = "none";
      shell-integration-features = "ssh-env";
    };
  };
}
