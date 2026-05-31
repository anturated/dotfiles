{
  programs.lazygit = {
    # enable it globally for now just in case
    enable = true;

    settings = {
      # nixos handles updates
      update.method = "never";

      git = {
        pagers = [
          { pager = "delta --paging=never"; }
        ];
      };
    };
  };
}
