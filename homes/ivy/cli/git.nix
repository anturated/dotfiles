{
  pkgs,
  config,
  ...
}:

{
  programs = {
    git = {
      enable = true;
      package = pkgs.gitMinimal;

      lfs = {
        enable = false;
        skipSmudge = true;
      };

      # git commit signing
      signing = {
        format = "ssh";
        key = "${config.home.homeDirectory}/.ssh/id_ed25519.pub";
        signByDefault = true;
      };

      ignores = [
        # system residue
        ".cache/"
        ".DS_Store"
        ".Trashes"
        ".Trash-*"
        "*.bak"
        "*.swp"
        "*.swo"
        "*.elc"
        ".~lock*"

        # build residue
        "tmp/"
        "target/"
        "result"
        "result-*"
        "*.exe"
        "*.exe~"
        "*.dll"
        "*.so"
        "*.dylib"

        # dependencies
        ".direnv/"
        "node_modules"
        "vendor"
      ];

      settings = {
        # TODO: remove to all-users
        user = {
          name = "Desant";
          email = "desant" + "@" + "anturated" + "." + "dev"; # obsfuscate email to prevent webscrapper spam
        };

        init.defaultBranch = "master";
        repack.usedeltabaseoffset = "true";
        color.ui = "auto";
        help.autocorrect = 10; # 1 second warning to a typo'd command

        diff = {
          algorithm = "histogram"; # a much better diff
          colorMoved = "plain"; # show moved lines in a different color
          mnemonicprefix = true;
        };

        core.whitespace = "fix,-indent-with-non-tab,trailing-space,cr-at-eol";

        # nice quality of life improvements
        branch = {
          autosetupmerge = "true";

          # sorts branches so the newst ones by latest commit are at the top
          sort = "committerdate";
        };

        commit.verbose = true;

        # prune branches that are no longer on the remote
        fetch.prune = true;

        pull = {
          # the default functionality is to push the current branch that i am on to the remote
          default = "current";

          # equivalent to --ff-only
          ff = "only";
        };

        # if a remote does not have a branch that i have, create it
        push.autoSetupRemote = true;

        # nicer diffing for merges
        merge = {
          stat = "true";
          conflictstyle = "zdiff3";
          tool = "meld";
        };

        rebase = {
          # https://andrewlock.net/working-with-stacked-branches-in-git-is-easier-with-update-refs/
          updateRefs = true;

          autoSquash = true;
          autoStash = true;
        };

        rerere = {
          enabled = true;
          autoupdate = true;
        };

        # prevent data corruption
        transfer.fsckObjects = true;
        fetch.fsckObjects = true;
        receive.fsckObjects = true;
      };
    };

    # pager / diff tool
    delta = {
      enable = true;
      enableGitIntegration = true;

      options = {
        navigate = true;
        side-by-side = true;
        line-numbers = true;
      };
    };
  };
}
