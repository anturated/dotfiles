{
  config,
  osConfig,
  ...
}:

let
  inherit (config.ceirios.programs) defaults;
in
{
  home.sessionVariables = {
    EDITOR = defaults.editor;
    GIT_EDITOR = defaults.editor;
    VISUAL = defaults.editor;
    TERMINAL = defaults.terminal;
    SYSTEMD_PAGERSECURE = "true";
    PAGER = defaults.pager;
    MANPAGER = defaults.manpager;
    FLAKE = osConfig.ceirios.system.flakeDir;
    DO_NOT_TRACK = 1;
  };

  programs.nushell.environmentVariables = config.home.sessionVariables;
}
