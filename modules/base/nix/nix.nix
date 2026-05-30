{ lib, inputs, ... }:

let
  inherit (lib)
    filterAttrs
    mapAttrs
    isType
    mkForce
    ;

  flakeInputs = filterAttrs (name: value: (isType "flake" value) && (name != "self")) inputs;
in
{
  nix = {
    # pin the registry to avoid downloading and evaluating a new nixpkgs version everytime
    registry = (mapAttrs (_: flake: { inherit flake; }) flakeInputs) // {
      # https://github.com/NixOS/nixpkgs/pull/388090
      nixpkgs = mkForce { flake = inputs.nixpkgs; };
    };

    # disable usage of nix channels
    channel.enable = false;

    settings = {
      # Free up to 20GiB whenever there is less than 5GB left.
      # this setting is in bytes, so we multiply with 1024 by 3
      min-free = 5 * 1024 * 1024 * 1024;
      max-free = 20 * 1024 * 1024 * 1024;

      # very dangerous bleeding edge stuff here
      experimental-features = [
        "nix-command"
        "flakes"
      ];

      # let me mess with the store
      allowed-users = [ "@wheel" ];
      trusted-users = [ "@wheel" ];

      # disable dirty tree warning
      warn-dirty = false;

      # let the system decide the number of max jobs
      max-jobs = "auto";

      # whether to accept nix configuration from a flake without prompting
      accept-flake-config = false;

      substituters = [
        "https://nix-community.cachix.org"
        "https://anturated.cachix.org"
      ];

      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "anturated.cachix.org-1:UbrvoKEvUKs/wEYeefuE1hP1oOXUXpvNa6pQMzMAUZQ="
      ];
    };

    # garbage collection
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    #  auto-optimize store
    optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };
  };
}
