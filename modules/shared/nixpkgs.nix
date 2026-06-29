{ ... }:

{
  nixpkgs.config = {
    # enable spyware
    allowUnfree = true;

    permittedInsecurePackages = [
      # FIXME: remove once vesktop updates deps
      "pnpm-10.29.2"
    ];
  };
}
