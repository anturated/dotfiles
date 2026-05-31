{ self, config, ... }:

let
  inherit (self.lib) anyHome;

  qh = anyHome config;
in
{
  # extract whatever shells home-manager has enabled
  # and enable them on system level. DRY.
  programs = {
    fish.enable = qh (c: c.programs.fish.enable);
    zsh.enable = qh (c: c.programs.zsh.enable);
  };
}
