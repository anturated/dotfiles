{ osConfig, lib, ... }:

let
  inherit (osConfig.ceirios.hardware) cpu gpu;
  inherit (lib.strings) optionalString;

  isHybrid = gpu == "nv-hybrid";

  primary = if isHybrid then "/dev/dri/${cpu}-gpu" else "/dev/dri/${gpu}-gpu";
  secondary = optionalString isHybrid ":/dev/dri/nvidia-gpu";
  devices = primary + secondary;

  env = optionalString (gpu != null) "hl.env(\"AQ_DRM_DEVICES\",\"${devices}\")";
in
env
