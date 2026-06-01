{ inputs }:

let
  inherit (inputs) self;

  mkSecret =
    {
      file,
      owner ? "root",
      group ? "root",
      mode ? "0400",
      ...
    }@args:
    let
      args' = removeAttrs args [
        "file"
        "owner"
        "group"
        "mode"
      ];
    in
    {
      sopsFile = "${self}/secrets/services/${file}.yaml";
      inherit owner group mode;
    }
    // args';
in
{
  inherit mkSecret;
}
