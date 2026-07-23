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
    # we wanna have some form of these to at least bootstrap the flake
    just
    gitMinimal
    sops

    nix-output-monitor # for just rebuild and all that
    ffmpeg # for just gif
  ];

  env.DIRENV_LOG_FORMAT = "";
}
