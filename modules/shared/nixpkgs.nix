{ ... }:

{
  nixpkgs.config = {

    permittedInsecurePackages = [
      # FIXME: remove once vesktop updates deps
      "pnpm-10.29.2"
    ];
  };
}
