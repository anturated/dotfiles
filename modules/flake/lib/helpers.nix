{ lib }:

let
  inherit (lib) getAttrFromPath any;

  anyHome =
    conf: cond:
    let
      list = map (
        user:
        getAttrFromPath [
          "home-manager"
          "users"
          user
        ] conf
      ) (builtins.attrNames conf.ceirios.system.users);
    in
    any cond list;

  mkPub = host: key: {
    "${host}-${key.type}" = {
      hostNames = [ host ];
      publicKey = "ssh-${key.type} ${key.key}";
    };
  };

  mkPubs = host: keys: lib.foldl' (acc: key: acc // mkPub host key) { } keys;
in
{
  inherit mkPubs anyHome;
}
