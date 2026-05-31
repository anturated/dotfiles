{
  lib,
  osClass,
  ...
}:

let
  inherit (lib) mapAttrs mkOption;
  inherit (lib.types) enum str;

  mkDefault = name: args: mkOption ({ description = "default ${name} for the system"; } // args);
in
{
  options.ceirios.software.defaults = mapAttrs mkDefault {
    shell = {
      type = enum [
        "bash"
        "fish"
      ];
      default = if (osClass == "nixos") then "fish" else "bash";
    };

    terminal = {
      type = enum [
        "kitty"
        "ghostty"
        "wezterm"
      ];
      default = "kitty";
    };

    editor = {
      type = enum [
        "nvim"
        "codium"
      ];
      default = "nvim";
    };

    pager = {
      type = str;
      default = "less -FR";
    };

    manpager = {
      type = str;
      default = "nvim +Man!";
    };
  };
}
