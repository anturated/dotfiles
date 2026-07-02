{
  lib,
  config,
  _class,
  ...
}:

let
  inherit (lib.attrsets) mergeAttrsList optionalAttrs;
  inherit (lib.options) mkOption;
  inherit (lib.types) lazyAttrsOf package;
in
{
  options.ceirios.packages = mkOption {
    type = lazyAttrsOf package;
    default = { };
    description = ''
      A set of packages to install.
      Replaces environment.systemPackages and home.packages
    '';
    example = lib.literalExpression ''
      ceirios.packages = {
        inherit (pkgs) obsidian;
      }'';
  };

  config = mergeAttrsList [
    (optionalAttrs (_class == "nixos" || _class == "darwin") {
      environment.systemPackages = builtins.attrValues config.ceirios.packages;
    })

    (optionalAttrs (_class == "homeManager") {
      home.packages = builtins.attrValues config.ceirios.packages;
    })
  ];
}
