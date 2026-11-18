{ config, ... }:

{
  programs.vesktop = {
    inherit (config.ceirios.profiles.graphical) enable;

    settings = {
      # disable auto update because it breaks vencord sometimes i guess
      autoUpdate = false;
      autoUpdateNotification = false;

      notifyAboutUpdates = false;
      useQuickCss = true;
      disableMinSize = true;
      minimizeToTray = false;
    };

    vencord.settings = {
      # load matugen theme
      enabledThemes = [ "matugen.css" ];
      plugins = {
        AlwaysExpandRoles.enabled = true;
        BetterGifPicker.enabled = true;
        CallTimer.enabled = true;
        ClearURLs.enabled = true;
        CrashHandler.enabled = true;
        FixImagesQuality.enabled = true;
        FriendsSince.enabled = true;
        ImageZoom.enabled = true;
        NoReplyMention.enabled = true;
        PermissionViewer.enabled = true;
        PictureInPicture.enabled = true;
        RevealAllSpoilers.enabled = true;
        ServerInfo.enabled = true;
        VolumeBooster = {
          enabled = true;
          multiplier = 4;
        };
        WebKeyBinds.enabled = true;
        WebScreenShareFixes.enabled = true;
      };
    };
  };

  # force override it idc what vesktop thinks.
  # note: this is because hm can't overwrite it if a backup exists which stops rebuilds.
  # the vesktop module defines these via home.file with absolute paths,
  # not xdg.configFile
  home.file = {
    "${config.xdg.configHome}/vesktop/settings.json".force = true;
    "${config.xdg.configHome}/vesktop/settings/settings.json".force = true;
  };
}
