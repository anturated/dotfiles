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
  # prevent using ~/.config/nixpkgs/config.nix
  environment.variables.NIXPKGS_CONFIG = lib.mkForce "";

  # enable spyware
  nixpkgs.config.allowUnfree = true;

  nix = {
    # pin the registry to avoid downloading and evaluating a new nixpkgs version everytime
    registry = (mapAttrs (_: flake: { inherit flake; }) flakeInputs) // {
      # https://github.com/NixOS/nixpkgs/pull/388090
      nixpkgs = mkForce { flake = inputs.nixpkgs; };
    };

    # disable usage of nix channels
    channel.enable = false;

    settings = {
      # free up to 20GiB whenever there is less than 5GB left.
      # values are in bytes, gb = b^3
      min-free = 1024 * 1024 * 1024 * 5;
      max-free = 1024 * 1024 * 1024 * 20;

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

      # prevent potential privillege escalation on foreign flakes
      accept-flake-config = false;

      # use binary caches to maybe avoid building
      substituters = [
        "https://nix-community.cachix.org"
        "https://anturated.cachix.org" # my riced stuff (qs, nvim, etc.)
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "anturated.cachix.org-1:UbrvoKEvUKs/wEYeefuE1hP1oOXUXpvNa6pQMzMAUZQ="
      ];
    };

    # delete unused stuff sometimes
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    # save space by simlinking sometimes
    optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };
  };
}
