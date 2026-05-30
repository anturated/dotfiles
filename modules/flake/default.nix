{ inputs }:

let
  inherit (inputs) nixpkgs self;
  inherit (nixpkgs) lib;

  forAllSystems =
    f: lib.genAttrs lib.systems.flakeExposed (system: f (import nixpkgs { inherit system; }));

  mkHosts = lib.mapAttrs self.lib.mkHost;

  # auto-discover from machines/
  machineNames = builtins.attrNames (
    lib.filterAttrs (_: type: type == "directory") (builtins.readDir (self + "/machines"))
  );

  discovered = lib.genAttrs machineNames (_: { });
in
{
  lib = import ./lib { inherit lib inputs; };

  nixosConfigurations = mkHosts (
    discovered

    # manual overrides go here
    // {
      saeth = {
        class = "iso";
      };
    }
  );

  devShells = forAllSystems (pkgs: {
    default = pkgs.callPackage ./shell.nix { };
  });
}
