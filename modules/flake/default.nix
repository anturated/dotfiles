{ inputs }:

let
  inherit (inputs) nixpkgs self;
  inherit (nixpkgs) lib;

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
}
