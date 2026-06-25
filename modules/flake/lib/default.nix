{ lib, inputs }:

lib.fixedPoints.makeExtensible (final: {
  services = import ./services.nix { inherit lib; };
  helpers = import ./helpers.nix { inherit lib; };
  mkHost = import ./mkHost.nix { inherit inputs lib; };
  secrets = import ./secrets.nix { inherit inputs; };
  template = import ./template; # templates, selections of code that are repeated

  inherit (final.services) mkServiceOption;
  inherit (final.helpers) mkPubs anyHome;
  inherit (final.secrets) mkSecret;
})
