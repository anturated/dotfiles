{
  lib,
  pkgs,
  machineOptions,
  ...
}:

let
  inherit (lib.attrsets) filterAttrs removeAttrs;

  ceiriosOptions = filterAttrs (n: _: n == "ceirios") machineOptions;

  filteredOptions = {
    ceirios = removeAttrs ceiriosOptions.ceirios [ "services" ];
  };

  docs = pkgs.nixosOptionsDoc {
    options = filteredOptions;
  };
in
docs.optionsCommonMark
