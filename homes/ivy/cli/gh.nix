{
  lib,
  config,
  ...
}:

{
  programs.gh = {
    enable = config.ceirios.profiles.workstation;

    extensions = lib.attrValues {
      # inherit (pkgs)
      #   gh-dash # tui
      #   ;
    };

    settings = {
      git_protocol = "ssh";
      prompt = "enabled";
    };
  };
}
