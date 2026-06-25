{ pkgs, lib, ... }:

{
  # we use ssh to sign stuff
  # but since i made this i'll leave it here in case i might need it
  config = lib.mkIf false {
    # client
    ceirios.packages = { inherit (pkgs) gnupg; };

    # signing daemon
    # https://search.nixos.org/options?channel=25.11&query=security.pam.services.%3Cname%3E.gnupg#show=option%253Asecurity.pam.services.%253Cname%253E.gnupg.enable
    services.gpg-agent = {
      enable = true;

      # allow pam auto-unlock
      extraConfig = "allow-preset-passphrase";

      pinentry.package = pkgs.pinentry-qt;
    };

    # keygrip for pam auto-unlock
    home.file.".pam-gnupg".text = "B7C1B3D12B33324577B6347325FCD30A4BF2C916\n";
  };
}
