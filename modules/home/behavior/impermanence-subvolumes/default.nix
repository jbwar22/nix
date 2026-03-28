{ config, lib, ns, ... }:

with lib; {
  options = ns.opt {
    enable = mkEnableOption "home impermanence";
    paths = mkOption {
      type = with types; listOf (coercedTo str (x:
        if typeOf x == "string" then {
          path = x;
        } else x
      ) (submodule {
        options = {
          path = mkStrOption "path";
          file = mkEnableOption "is the path a file rather than a dir";
          origin = mkOption {
            type = nullOr str;
            description = "origin of path";
            default = null;
          };
          neededForBoot = mkEnableOption "needed in early stages";
        };
      }));
      description = "extra paths to persist, back";
      default = [];
    };
  };
}
