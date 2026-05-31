{ config, lib, ... }:

let
  inherit (lib) mkOption types;
  inherit (types) int;

  cfg = config.ceirios.boot;
in
{
  # using generic because this is too much for default.nix
  options.ceirios.boot = {
    timeout = mkOption {
      type = int;
      default = 0;
      description = ''
        Time to choose derivation.
        If 0 you can still press ESC'';
    };
  };

  config.boot = {
    loader = {
      # time to choose derivation
      # (0 still lets you press ESC)
      inherit (cfg) timeout;

      efi.canTouchEfiVariables = true;
    };

    # something related to boot logs (probably)
    consoleLogLevel = 3;
    initrd.verbose = false;

    # i have ONE ntfs partition and it needs to go
    supportedFilesystems = [ "ntfs" ];
  };
}
