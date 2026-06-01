# following https://github.com/NixOS/nixpkgs/blob/77ee426a4da240c1df7e11f48ac6243e0890f03e/lib/default.nix
# as a rough template we can create our own extensible lib and expose it to the flake
# we can then use that elsewhere like our hosts
{ lib, inputs }:

lib.fixedPoints.makeExtensible (final: {
  services = import ./services.nix { inherit lib; };
  helpers = import ./helpers.nix { inherit lib; };
  mkHost = import ./mkHost.nix { inherit inputs lib; };
  secrets = import ./secrets.nix { inherit inputs; };
  template = import ./template; # templates, selections of code that are repeated

  inherit (final.services) mkGraphicalService mkServiceOption;
  inherit (final.helpers) mkPubs anyHome;
  inherit (final.secrets) mkSecret;
})
