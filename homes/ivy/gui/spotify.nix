{
  inputs,
  inputs',
  lib,
  config,
  ...
}:

let
  inherit (lib.modules) mkIf;
  inherit (config.ceirios.profiles) graphical;

  spicetifyPkgs = inputs'.spicetify.legacyPackages;
in
{
  imports = [ inputs.spicetify.homeManagerModules.spicetify ];

  config = mkIf graphical.enable {

    # this installs spotify too probably
    programs.spicetify = {
      enable = true;
      # theme = spicetifyPkgs.themes.comfy ;
    };
  };
}
