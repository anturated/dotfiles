{
  lib,
  config,
  pkgs,
  ...
}:

let
  inherit (lib.modules) mkIf mkForce;
  inherit (lib.meta) getExe;
  inherit (config.ceirios.profiles) graphical;

  # spicetifyPkgs = inputs'.spicetify.legacyPackages;

  # spotify only registers the spotify: scheme, so open.spotify.com links
  # land in the browser. route http(s) through this and rewrite them.
  url-dispatch = pkgs.writeShellApplication {
    name = "url-dispatch";

    runtimeInputs = [
      pkgs.spotify
      pkgs.vivaldi
    ];

    text = ''
      re='^https?://open\.spotify\.com/(intl-[a-zA-Z-]+/)?(track|album|playlist|artist|episode|show|user)/([A-Za-z0-9]+)'

      web=()
      for url in "$@"; do
        if [[ $url =~ $re ]]; then
          spotify "spotify:''${BASH_REMATCH[2]}:''${BASH_REMATCH[3]}" &>/dev/null &
          disown
        else
          web+=("$url")
        fi
      done

      if (( ''${#web[@]} )) || (( $# == 0 )); then
        exec vivaldi "''${web[@]}"
      fi
    '';
  };
in
{
  # imports = [ inputs.spicetify.homeManagerModules.spicetify ];

  config = mkIf graphical.enable {

    # this installs spotify too probably
    # programs.spicetify = {
    #   enable = true;
    #   # theme = spicetifyPkgs.themes.comfy ;
    # };

    ceirios.packages = {
      inherit (pkgs) spotify;
      inherit url-dispatch;
    };

    xdg.desktopEntries.url-dispatch = {
      name = "URL Dispatcher";
      exec = "${getExe url-dispatch} %U";
      noDisplay = true;
      mimeType = [
        "x-scheme-handler/http"
        "x-scheme-handler/https"
      ];
    };

    xdg.mimeApps.defaultApplications = {
      "x-scheme-handler/http" = mkForce [ "url-dispatch.desktop" ];
      "x-scheme-handler/https" = mkForce [ "url-dispatch.desktop" ];
    };
  };
}
