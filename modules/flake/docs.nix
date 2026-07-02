{
  lib,
  pkgs,
  machine,
  ...
}:

let
  inherit (lib.attrsets) filterAttrs removeAttrs recursiveUpdate;

  # grab system options
  ceiriosOptions = filterAttrs (n: _: n == "ceirios") machine.options;
  filteredOptions = {
    ceirios = removeAttrs ceiriosOptions.ceirios [ "services" ];
  };

  # grab home options
  homeOptions = filterAttrs (n: _: n == "ceirios") (
    machine.options.home-manager.users.type.getSubOptions [
      "home-manager"
      "users"
    ]
  );
  filteredHomeOptions = {
    ceirios = removeAttrs homeOptions.ceirios [ "profiles" ];
  };

  docs = pkgs.nixosOptionsDoc {
    options = recursiveUpdate filteredOptions filteredHomeOptions;
  };
in
docs.optionsCommonMark
