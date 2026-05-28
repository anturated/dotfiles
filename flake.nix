{
  description = "This might as well be a distro at this point.";

  outputs = inputs: import ./modules/flake { inherit inputs; };

  inputs = {
    # might switch to this if i care
    # nixpkgs.url = "https://channels.nixos.org/nixpkgs-unstable/nixexprs.tar.xz";
    nixpkgs = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      ref = "nixos-unstable";
    };

    # stable branch is here because nvim likes breaking changes.
    # should be used as pkgsStable
    nixpkgs-stable = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      ref = "nixos-25.11";
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

    # quickly deploy my stuff
    fywion = {
      type = "github";
      owner = "anturated";
      repo = "fywion";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # my nvim config
    newydd = {
      type = "github";
      owner = "anturated";
      repo = "nvim";
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
  };
}
