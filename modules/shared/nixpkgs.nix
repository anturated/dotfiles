{ pkgs, ... }:

{
  nixpkgs.config = {
    # enable spyware
    allowUnfree = true;

    permittedInsecurePackages = [
    ];
  };

  # disallow overlays
  assertions = [
    {
      assertion = pkgs.overlays == [ ];
      message = "No overlays pls";
    }
  ];
}
