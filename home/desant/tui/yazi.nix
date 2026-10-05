{ ... }:

{
  programs.yazi = {
    enable = true;

    # TODO: probably should add the rest of them
    enableFishIntegration = true;

    keymap = {

      mgr.prepend_keymap = [
        # copy to system clipboard
        # https://yazi-rs.github.io/docs/tips#selected-files-to-clipboard
        {
          on = "y";
          run = [
            ''shell -- for path in %s; do echo "file://$path"; done | wl-copy -t text/uri-list''
            "yank"
          ];
        }
      ];
    };
  };
}
