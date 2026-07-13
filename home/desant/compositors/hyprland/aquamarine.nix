{ osConfig, lib, ... }:

let
  inherit (osConfig.ceirios.hardware) cpu gpu busIds;
  inherit (lib.strings) optionalString;

  # set hyprland up to recognize monitors wired to other GPUs.
  # this'll only ever work if we have the cards bound, which requires busids to be set
  # TODO: this is still not as flexible as i want but will work in most cases
  isHybrid = gpu == "nv-hybrid";
  hasBusIds = (busIds.primary != null && busIds.discrete != null);

  devices = "/dev/dri/${cpu}-gpu:/dev/dri/nvidia-gpu";

  env = optionalString (isHybrid && hasBusIds) "hl.env(\"AQ_DRM_DEVICES\",\"${devices}\")";
in
env
