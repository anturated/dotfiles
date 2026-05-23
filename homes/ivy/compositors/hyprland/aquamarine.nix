{ osConfig, ... }:

let
  inherit (osConfig.ceirios.hardware) cpu gpu;

  isHybrid = gpu == "nv-hybrid";

  primary = if isHybrid then "/dev/dri/${cpu}-gpu" else "/dev/dri/${gpu}-gpu";
  secondary = if isHybrid then ":/dev/dri/nvidia-gpu" else "";
  devices = primary + secondary;
in
"hl.env(\"AQ_DRM_DEVICES\",\"${devices}\")"
