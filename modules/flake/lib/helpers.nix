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
      ) (builtins.attrNames conf.ceirios.users);
    in
    any cond list;

  mkPub = host: key: {
    "${host}-${key.type}" = {
      hostNames = [ host ];
      publicKey = "ssh-${key.type} ${key.key}";
    };
  };

  mkPubs = host: keys: lib.foldl' (acc: key: acc // mkPub host key) { } keys;

  pciAddr =
    busId:
    let
      parts = lib.splitString ":" busId;
    in
    "0000:${lib.fixedWidthString 2 "0" (builtins.elemAt parts 0)}"
    + ":${lib.fixedWidthString 2 "0" (builtins.elemAt parts 1)}"
    + ".${builtins.elemAt parts 2}";
in
{
  inherit mkPubs anyHome pciAddr;
}
