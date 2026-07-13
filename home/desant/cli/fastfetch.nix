{ user, host, ... }:

let
  width = 46; # total display-character width of the title line

  title = "${user}@${host}";
  titleLen = builtins.stringLength title; # safe: user/host are ASCII

  totalDashes = width - 4 - titleLen; # corners eat 2 chars
  leftDashes = totalDashes / 2; # should floor
  rightDashes = totalDashes - leftDashes; # picks up the odd one

  repeat = char: n: builtins.concatStringsSep "" (builtins.genList (_: char) n);

  titleLine = "• ${repeat "─" leftDashes}${title}${repeat "─" rightDashes} •";

  spacerWidth = width - 4;
  colorsWidth = 3 * 8 - 1;
  colorsPadding = width / 2 - colorsWidth / 2;
in
{
  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        type = "small";
        padding = {
          top = 2;
          left = 3;
          right = 1;
        };
        color = {
          "1" = "white";
          "2" = "blue";
          "3" = "white";
          "4" = "blue";
          "5" = "white";
          "6" = "blue";
        };
      };
      modules = [
        {
          type = "custom";
          format = "";
        }
        {
          type = "title";
          format = titleLine;
        }
        {
          type = "os";
          key = "   ";
          keyColor = "blue";
        }
        {
          type = "kernel";
          format = "{release}";
          key = "   ";
          keyColor = "cyan";
        }
        {
          type = "cpu";
          format = "{name}";
          key = "   ";
          keyColor = "red";
        }
        {
          type = "gpu";
          # truncate this because its just big sometimes
          format = "{name:${toString (spacerWidth - 4)}}";
          key = "   ";
          keyColor = "green";
        }
        {
          type = "gpu";
          format = "{driver}";
          key = "   ";
          keyColor = "magenta";
        }
        # {
        #   type = "packages";
        #   key = "   ";
        #   keyColor = "yellow";
        # }
        # {
        #   type = "uptime";
        #   key = "   ";
        #   keyColor = "white";
        # }
        {
          type = "custom";
          format = "• ${repeat "─" spacerWidth} •";
        }
        {
          type = "custom";
          format = "${repeat " " colorsPadding}{#red}  {#green}  {#yellow}  {#blue}  {#magenta}  {#cyan}  {#white}  {#black}  ";
        }
        {
          type = "custom";
          format = "";
        }
        {
          type = "custom";
          format = "";
        }
      ];
    };
  };
}
