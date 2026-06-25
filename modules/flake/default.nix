{ inputs }:

let
  # put overrides here, the rest is automated below
  overrides = {
    saeth = {
      class = "iso";
    };
  };

  inherit (inputs) nixpkgs self;
  inherit (nixpkgs) lib;
  inherit (lib)
    genAttrs
    filterAttrs
    readDir
    attrNames
    mapAttrs
    ;

  systems = [
    "x86_64-linux"
    "aarch64-linux"
    "aarch64-darwin"
  ];

  forAllSystems = f: genAttrs systems (system: f nixpkgs.legacyPackages.${system});

  mkHosts = mapAttrs self.lib.mkHost;

  # auto-discover from machines/
  machineNames = attrNames (
    filterAttrs (_: type: type == "directory") (readDir (self + "/machines"))
  );

  discovered = genAttrs machineNames (_: { });
in
{
  lib = import ./lib { inherit lib inputs; };

  nixosConfigurations = mkHosts (discovered // overrides);

  # docs generator
  # this'll run on linux so x86_64 should be fine
  # ceirios.services is omitted
  packages.x86_64-linux.optionsDocs =
    let
      inherit (self.nixosConfigurations.legion) options;
      ceiriosOptions = lib.filterAttrs (n: _: n == "ceirios") options;

      dropTheseOptions = [ "services" ];
      filteredOptions = {
        ceirios = lib.removeAttrs ceiriosOptions.ceirios dropTheseOptions;
      };

      docs = nixpkgs.legacyPackages.x86_64-linux.nixosOptionsDoc {
        options = filteredOptions;
      };
    in
    docs.optionsCommonMark;

  devShells = forAllSystems (pkgs: {
    default = pkgs.callPackage ./shell.nix { };
  });
}
