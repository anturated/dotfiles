{ pkgs, ... }:

{
  ceirios.packages = {
    ceirios-upd = pkgs.writeShellApplication {
      name = "upd";

      runtimeInputs = with pkgs; [
        nix-output-monitor
      ];

      text = ''
        : "''${FLAKE:?upd: \$FLAKE not set}"
        [[ -d $FLAKE ]] || { echo "$FLAKE doesn't exist" >&2; exit 1; }

        cd "$FLAKE"

        branch=$(git branch --show-current)
        [[ $branch == master ]] || { echo "not master" >&2; exit 1; }

        echo "Pulling..."
        git pull --rebase

        # sudo so that fwupd doesnt fail
        sudo nixos-rebuild switch \
          --flake . \
          --log-format internal-json \
          --no-reexec \
          --sudo \
          |& nom --json
      '';
    };
  };
}
