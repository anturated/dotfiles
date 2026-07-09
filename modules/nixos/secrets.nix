{ inputs, ... }:

{
  imports = [ inputs.sops.nixosModules.sops ];

  sops = {
    # sudo , age-keygen -o /var/lib/sops-nix/key.txt
    age.keyFile = "/var/lib/sops-nix/key.txt";

    # don't load extra keys
    gnupg.sshKeyPaths = [ ];
  };
}
