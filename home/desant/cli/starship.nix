{
  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;
      format = "$username" + "$directory" + "$git_branch" + "$git_status" + "$character";

      right_format =
        "$rust"
        + "$golang"
        + "$docker_context"
        + "$java"
        + "$python"
        + "$nodejs"
        + "$lua"
        + "$package"
        + "$nix_shell";

      username = {
        format = "[ $user ]($style)[](blue)";
        style_user = "fg:bold black bg:blue"; # this won't apply to root so don't worry
        show_always = false; # only show on ssh
      };

      directory = {
        format = "[ $path]($style)";
        style = "bold blue";
        truncate_to_repo = true;
        truncation_length = 0;
        truncation_symbol = "";
      };

      git_branch = {
        format = "[\\(](bold blue)[$branch](bold red)[\\)](bold blue)";
        symbol = " ";
      };

      git_status = {
        format = "[$ahead_behind](white)";

        untracked = "[/](bold dimmed white)";
        modified = "[/](bold orange)";
        deleted = "[/](bold red)";
        renamed = "[/](bold yellow)";
        typechanged = "[/](bold blue)";

        staged = "[/](bold green)";
        stashed = "[/](bold cyan)";

        ahead = "⇡\${count}";
        behind = "⇣\${count}";
        diverged = "⇡\${ahead_count}⇣\${behind_count}";

        conflicted = "[CONFLICT](bold red)";
      };

      character = {
        error_symbol = " [󱋙 ](bold red)";
        success_symbol = " [󰌪 ](bold green)";
      };

      fill = {
        symbol = "─";
      };

      aws = {
        symbol = " ";
      };

      conda = {
        symbol = " ";
      };

      dart = {
        symbol = " ";
      };

      docker_context = {
        symbol = " ";
      };

      elixir = {
        symbol = " ";
      };

      elm = {
        symbol = " ";
      };

      golang = {
        symbol = "󰟓 ";
        format = " [\${symbol}](\$style)";
      };

      hg_branch = {
        symbol = " ";
      };

      java = {
        symbol = " ";
      };

      julia = {
        symbol = " ";
      };

      nim = {
        symbol = " ";
      };

      nix_shell = {
        symbol = " ";
        impure_msg = "[\$name  ](dimmed white)";
        pure_msg = "[\$name  ](bold blue)";
        unknown_msg = "[ \$name (UNKNOWN)](bold red)";
        format = "\$state";
      };

      nodejs = {
        symbol = "󰎙 ";
        format = " [\${symbol}](\$style)";
      };

      package = {
        symbol = " ";
        format = " [(\$version)](\$style)";
      };

      perl = {
        symbol = " ";
      };

      php = {
        symbol = " ";
      };

      python = {
        symbol = " ";
        format = " [\$virtualenv \${symbol}](\$style)";
      };

      ruby = {
        symbol = " ";
      };

      rust = {
        symbol = " ";
        format = " [\$virtualenv \${symbol}](\$style)";
      };

      swift = {
        symbol = "ﯣ ";
      };

      lua = {
        symbol = " ";
        format = " [\${symbol}](\$style)";
      };
    };
  };
}
