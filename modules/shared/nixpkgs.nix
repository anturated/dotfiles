{ pkgs, ... }:

{
  nixpkgs.config = {
    # enable spyware
    allowUnfree = true;

    permittedInsecurePackages = [
      "electron-40.10.5"
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
