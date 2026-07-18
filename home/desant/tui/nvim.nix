{ inputs, ... }:

{
  imports = [ inputs.newydd.homeModules.default ];

  programs.newydd = {
    enable = true;
  };
}
