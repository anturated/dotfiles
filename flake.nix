{
  description = "This might as well be a distro at this point.";

  outputs = inputs: import ./modules/flake { inherit inputs; };

  inputs = {
    nixpkgs = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      ref = "nixpkgs-unstable";
    };

    # userspace configs
    home-manager = {
      type = "github";
      owner = "nix-community";
      repo = "home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ### extra stuff ###

    # spotify themes & plugins
    spicetify = {
      type = "github";
      owner = "Gerg-L";
      repo = "spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # need this for comma to work
    nix-index-database = {
      type = "github";
      owner = "nix-community";
      repo = "nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # secrets
    sops = {
      type = "github";
      owner = "Mic92";
      repo = "sops-nix";
      ref = "pull/779/merge";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # mail server
    simple-nixos-mailserver = {
      type = "gitlab";
      owner = "simple-nixos-mailserver";
      repo = "nixos-mailserver";

      inputs = {
        nixpkgs.follows = "nixpkgs";
        git-hooks.follows = "";
        flake-compat.follows = "";
        blobs.follows = "";
      };
    };

    ### my stuff ###

    # my website
    anturated-website = {
      type = "git";
      url = "https://git.anturated.dev/anturated/website";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # my nvim config
    newydd = {
      type = "git";
      url = "https://git.anturated.dev/anturated/newydd";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # my quickshell config
    eiddew = {
      type = "git";
      url = "https://git.anturated.dev/anturated/eiddew";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
