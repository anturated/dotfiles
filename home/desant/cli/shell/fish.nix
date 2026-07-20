{
  lib,
  config,
  ...
}:

let
  inherit (lib.strings) optionalString;
  inherit (lib.modules) mkIf;
  inherit (config.ceirios.profiles) gaming workstation graphical;
  inherit (config.ceirios.programs.defaults) terminal;
in
{
  programs.fish = {
    enable = true;

    shellInit = ''
      # source .fish_profile if present
      if test -f ~/.fish_profile
          source ~/.fish_profile
      end

      # ~/.local/bin first, depot_tools last
      fish_add_path --prepend ~/.local/bin
      if test -d ~/Applications/depot_tools
          fish_add_path --append ~/Applications/depot_tools
      end

      ${optionalString gaming.enable ''
        # asdf shims
        if test -z "$ASDF_DATA_DIR"
            set _asdf_shims "$HOME/.asdf/shims"
        else
            set _asdf_shims "$ASDF_DATA_DIR/shims"
        end
        if not contains $_asdf_shims $PATH
            set -gx --prepend PATH $_asdf_shims
        end
        set --erase _asdf_shims
      ''}

      # matugen theme
      if test -f ~/.config/fish/theme.fish
          source ~/.config/fish/theme.fish
      end
    '';

    interactiveShellInit = ''
      # man pages via bat
      set -x MANROFFOPT "-c"
      set -x MANPAGER "sh -c 'col -bx | bat -l man -p'"

      # bang-bang shortcuts: !! repeats last command, !$ repeats last argument
      if [ "$fish_key_bindings" = fish_vi_key_bindings ]
          bind -Minsert ! __history_previous_command
          bind -Minsert '$' __history_previous_command_arguments
      else
          bind ! __history_previous_command
          bind '$' __history_previous_command_arguments
      end

      # tool integrations
      starship init fish | source
      zoxide init fish | source
      ${optionalString workstation.enable "direnv hook fish | source"}
    '';

    functions = {
      zn = {
        description = "zoxide + direnv + nvim";
        body = ''
          if test (count $argv) -eq 0
              echo "Usage: zn <directory>"
              return 1
          end

          z $argv[1]

          if test -f .envrc
              eval (direnv export fish)
          end

          nvim
        '';
      };

      fish_greeting = {
        description = "exec on start";
        body = optionalString graphical.enable "fastfetch";
      };

      # !! — repeat last command
      __history_previous_command = {
        body = ''
          switch (commandline -t)
          case "!"
              commandline -t $history[1]; commandline -f repaint
          case "*"
              commandline -i !
          end
        '';
      };

      # !$ — repeat last argument
      __history_previous_command_arguments = {
        body = ''
          switch (commandline -t)
          case "!"
              commandline -t ""
              commandline -f history-token-search-backward
          case "*"
              commandline -i '$'
          end
        '';
      };
    };

    # aliases
    shellAliases = {
      # navigation
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      "....." = "cd ../../../..";
      "......" = "cd ../../../../..";

      # file listing — eza
      ls = "eza     --color=always --group-directories-first --icons=always";
      ll = "eza -l  --color=always --group-directories-first --icons=always";
      la = "eza -la --color=always --group-directories-first --icons=always";
      lt = "eza -T  --color=always --group-directories-first --icons=always";
      lT = "eza -aT --color=always --group-directories-first --icons=always";
      "l." = ''eza -a | grep -e "^\."'';

      # System
      jctl = "journalctl -p 3 -xb";

      # Networking
      refreshwifi = "nmcli device wifi rescan";

      # kitty ssh
      ssh = mkIf (terminal == "kitty") "kitten ssh";

      # grep / color wrappers
      grep = "grep --color=auto";
      fgrep = "fgrep --color=auto";
      egrep = "egrep --color=auto";
      dir = "dir --color=auto";
      vdir = "vdir --color=auto";

      # Misc
      ff = "fastfetch";
    };
  };
}
