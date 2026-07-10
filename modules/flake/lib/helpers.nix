{ lib }:

let
  inherit (lib.attrsets) getAttrFromPath attrNames;
  inherit (lib.lists) any elemAt;
  inherit (lib.types) port;
  inherit (lib.options) mkOption;

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
      ) (attrNames conf.ceirios.users);
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
    "0000:${lib.fixedWidthString 2 "0" (elemAt parts 0)}"
    + ":${lib.fixedWidthString 2 "0" (elemAt parts 1)}"
    + ".${elemAt parts 2}";

  mkPortOption =
    defaultPort:
    mkOption {
      type = port;
      default = defaultPort;
    };
in
{
  inherit
    mkPubs
    anyHome
    pciAddr
    mkPortOption
    ;
}
