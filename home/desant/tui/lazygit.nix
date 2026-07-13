{
  programs.lazygit = {
    # enable it globally for now just in case
    enable = true;

    settings = {
      # nixos handles updates
      update.method = "never";

      git = {
        # allow rewording past commmits
        overrideGpg = true;

        # use delta pager
        pagers = [
          { pager = "delta --paging=never"; }
        ];
      };
    };
  };
}
