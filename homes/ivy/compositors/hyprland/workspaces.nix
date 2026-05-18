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
  inherit (osConfig.ceirios) hardware;
  # use the name from values because it may be overridden
  monitors =
    let
      mons = builtins.attrValues hardware.monitors;
    in
    builtins.sort (a: b: a.name == hardware.mainMonitor) mons;

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
