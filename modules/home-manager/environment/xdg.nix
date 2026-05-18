{
  lib,
  config,
  pkgs,
  self,
  ...
}:

let
  inherit (lib.modules) mkIf mkForce;
  inherit (lib.lists) concatLists;
  inherit (pkgs.stdenv.hostPlatform) isLinux;

  template = self.lib.template.xdg;
  vars = template.user config.xdg;

  appsToAssoc = {
    browser = {
      app = "chromium-browser";
      mimeTypes = [
        "text/html"
        "application/pdf"
        "x-www-browser"
        "x-scheme-handler/http"
        "x-scheme-handler/https"
        "x-scheme-handler/ftp"
        "x-scheme-handler/about"
        "x-scheme-handler/unknown"
      ];
    };

    code = {
      app = "nvim";
      mimeTypes = [
        "application/json"
        "text/english"
        "text/plain"
        "text/x-makefile"
        "text/x-c++hdr"
        "text/x-c++src"
        "text/x-chdr"
        "text/x-csrc"
        "text/x-java"
        "text/x-moc"
        "text/x-pascal"
        "text/x-tcl"
        "text/x-tex"
        "application/x-shellscript"
        "text/x-c"
        "text/x-c++"
      ];
    };

    # import all types from here:
    # find /run/current-system/sw/share/mime -name '*.xml' | xargs grep -h 'type=' | grep -oP 'type="\K[^"]+' | grep -E '^(image|video|audio)/' | sort -u

    media = {
      app = "mpv";
      mimeTypes = concatLists [
        (import ./mime/video.nix)
        (import ./mime/audio.nix)
      ];
    };

    images = {
      app = "mpv";
      mimeTypes = (import ./mime/image.nix);
    };

    fileManager = {
      app = "nemo";
      mimeTypes = [ "inode/directory" ];
    };
  };

  associations' = lib.concatMapAttrs (
    _: val: lib.listToAttrs (lib.map (mt: lib.nameValuePair mt "${val.app}.desktop") val.mimeTypes)
  ) appsToAssoc;

  specifics = {
    "x-scheme-handler/spotify" = [ "spotify.desktop" ];
    "x-scheme-handler/discord" = [ "discord.desktop" ];
  };

  associations = associations' // specifics;
in
{
  xdg = {
    enable = true;

    cacheHome = "${config.home.homeDirectory}/.cache";
    configHome = "${config.home.homeDirectory}/.config";
    dataHome = "${config.home.homeDirectory}/.local/share";
    stateHome = "${config.home.homeDirectory}/.local/state";

    userDirs = mkIf isLinux {
      enable = true;
      createDirectories = true;
      setSessionVariables = true;

      documents = "${config.home.homeDirectory}/documents";
      download = "${config.home.homeDirectory}/downloads";
      desktop = "${config.home.homeDirectory}/desktop";
      videos = "${config.home.homeDirectory}/media/videos";
      music = "${config.home.homeDirectory}/media/music";
      pictures = "${config.home.homeDirectory}/media/pictures";
      publicShare = "${config.home.homeDirectory}/public/share";
      templates = "${config.home.homeDirectory}/public/templates";
      projects = "${config.home.homeDirectory}/dev";

      extraConfig = {
        SCREENSHOTS = "${config.xdg.userDirs.pictures}/screenshots";
        DEV = "${config.home.homeDirectory}/dev";
      };
    };

    mimeApps = {
      enable = isLinux;
      associations.added = associations;
      defaultApplications = associations;
    };
    # disable in home, let nixos manage it
    portal.enable = lib.mkForce false;
  };

  home.sessionVariables = vars // {
    GNUPGHOME = mkForce vars.GNUPGHOME;
  };
}
