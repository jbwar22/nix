{ config, lib, ... }:

with lib; with ns config ./.; {
  options = opt (mkOption {
    description = "tmp file definitions";
    type = with types; attrsOf (submodule {
      options = {
        type = mkEnumOption "Type" [
          "f"  "f+" "w"  "w+" "d"  "D"  "e"  "v"  "q"  "Q"  "p"  "p+" "L"  "L+" "c"  "c+" "b"  "b+"
          "C"  "C+" "x"  "X"  "r"  "R"  "z"  "Z"  "t"  "T"  "h"  "H"  "a"  "a+" "A"  "A+"
        ];
        path = mkStrOption "Path";
        mode = mkStrOption "Mode";
        user = mkStrOption "User";
        group = mkStrOption "Group";
        age = mkStrOption "Group";
        argument = mkStrOption "Group";
      };
    });
    default = {};
  });

  config = {
    systemd.user.tmpfiles.rules = mapAttrsToList (_: f:
      "${f.type} ${f.path} ${f.mode} ${f.user} ${f.group} ${f.age} ${f.argument}"
    ) cfg;
  };
}
