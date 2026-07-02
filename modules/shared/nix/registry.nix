{ lib, inputs, ... }:

let
  inherit (lib.attrsets) filterAttrs attrValues mapAttrs;
  inherit (lib.modules) mkForce;
  inherit (lib.types) isType;

  flakeInputs = filterAttrs (name: value: (isType "flake" value) && (name != "self")) inputs;
in
{
  # make nix run, nix shell, etc. use the nixpkgs present on system
  # instead of downloading whatever's pinned in the flake we're running
  # https://github.com/NixOS/nixpkgs/pull/388090

  # kinda defeats the purpose of flakes being super reprocducible
  # but also ain't nobody updating those
  # and i'm not downloading 215 versions of nixpkgs

  # do NOT use nixpkgs pinned in the flake
  nixpkgs.flake.source = mkForce null;

  # do use the one we already have
  nix = {
    registry = (mapAttrs (_: flake: { inherit flake; }) flakeInputs);
    nixPath = attrValues (mapAttrs (k: v: "${k}=flake:${v.outPath}") flakeInputs);
  };
}
