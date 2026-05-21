{
  lib,
  config,
  ...
}:
let
  inherit (lib) elem mkIf;
in
{
  config = mkIf (elem "wizard" (builtins.attrNames config.ceirios.system.users)) {
    users.users.wizard = {
      hashedPassword = "$y$j9T$UjK.OcOZ2SDWoh4FGlGcD1$uBz3gUlhFKn1Ie9A6jC0kSE7rhfpXRYcXhsvgoS1PU7";
    };
  };
}
