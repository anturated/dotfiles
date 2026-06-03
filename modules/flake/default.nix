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
    systems
    filterAttrs
    readDir
    attrNames
    mapAttrs
    ;

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

  devShells = forAllSystems (pkgs: {
    default = pkgs.callPackage ./shell.nix { };
  });
}
