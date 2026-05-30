{
  mkShellNoCC,
  just,
  gitMinimal,
  sops,
  nix-output-monitor,
}:
mkShellNoCC {
  name = "ceirios";

  packages = [
    just
    gitMinimal
    sops
    nix-output-monitor
  ];

  env.DIRENV_LOG_FORMAT = "";
}
