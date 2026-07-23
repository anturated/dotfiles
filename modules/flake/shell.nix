{
  mkShellNoCC,
  just,
  gitMinimal,
  sops,
  nix-output-monitor,
  ffmpeg,
}:
mkShellNoCC {
  name = "ceirios";

  packages = [
    just
    gitMinimal
    sops
    nix-output-monitor
    ffmpeg
  ];

  env.DIRENV_LOG_FORMAT = "";
}
