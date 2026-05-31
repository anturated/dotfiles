{
  lib,
  config,
  _class,
  ...
}:

let
  inherit (lib) mergeAttrsList optionalAttrs mkOption;
  inherit (lib.types) lazyAttrsOf package;
in
{
  options.ceirios.packages = mkOption {
    type = lazyAttrsOf package;
    default = { };
    description = "A set of packages to install";
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
