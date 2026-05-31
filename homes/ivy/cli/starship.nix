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
        format = "[$user]($style)[](blue)";
        style_user = "fg:bold black bg:blue"; # this won't apply to root so don't worry
        show_always = false; # only show on ssh
      };

      directory = {
        format = "[ $path]($style)";
        style = "bold bluer";
        truncate_to_repo = true;
        truncation_length = 0;
        truncation_symbol = "";
      };

      palette = "ivy";

      palettes.ivy = {
        bluer = "#afc9d0";
        orang = "#BD6F3E";
        yello = "#dbb26c";
        pears = "#97ad6e";
      };

      palettes.cust = {
        flamingo = "#f2cdcd";
        maroon = "#eba0ac";
        peach = "#fab387";
      };

      git_branch = {
        format = "[\\(](bold blue)[$branch](bold cyan)[\\)](bold blue)";
        symbol = " ";
        style = "bold red";
      };

      git_status = {
        format = "[ ><](bold blue)[$all_status>](bold blue)[$ahead_behind]($style)";
        conflicted = "[*](bold red)";
        ahead = "⇡\${count}";
        behind = "⇣\${count}";
        diverged = "⇡\${ahead_count}⇣''\${behind_count}";
        untracked = "[/](bold green)";
        stashed = "[/](bold blue)";
        modified = "[/](bold orang)";
        staged = "[/](bold cyan)";
        renamed = "[/](bold yello)";
        typechanged = "[/](bold pears)";
        deleted = "[/](bold red)";
        style = "maroon";
      };

      character = {
        error_symbol = " [󱏳 ](bold red)";
        success_symbol = " [󰈺 ](bold blue)";
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
