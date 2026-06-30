{
  lib,
  config,
  ...
}:

{
  programs.gh = {
    inherit (config.ceirios.profiles.workstation) enable;

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
