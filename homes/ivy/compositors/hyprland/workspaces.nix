# RAAAAAAH
{
  lib,
  osConfig,
  ...
}:

let
  inherit (lib)
    concatStringsSep
    genList
    length
    elemAt
    ;
  # we only need names here, use the one in value because it may be overridden
  monitors = builtins.attrValues osConfig.ceirios.hardware.monitors;
  hasMonitor = monitors != [ ];

  # https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

  # generate 5 per monitor
  wsPerMon = 5;
  count = wsPerMon * (length monitors);

  # persist workspaces on the first mon
  # the rest i don't care
  isPersistent = index: if index < wsPerMon then "true" else "false";

  # get monitor name for the workspace
  idxToMon = index: (elemAt monitors (index / wsPerMon)).name;

  # rule generator
  mkRule = index: ''
    hl.workspace_rule({
      workspace = "${toString (index + 1)}",
      monitor = "${idxToMon index}",
      persistent = ${isPersistent index},
    })
  '';

  # generate
  configWorkspaces = concatStringsSep "" (genList mkRule count);

  # don't care to do fallbacks for now
  # but handle empty list
  allWorkspaces = if hasMonitor then configWorkspaces else "-- NO MONITORS CONFIGURED";
in
allWorkspaces
