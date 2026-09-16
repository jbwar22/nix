{ lib, clib, ns, ... }:

let
  inherit (lib) 
  mkEnableOption
  mkOption;
  inherit (lib.types)
  attrsOf
  submodule;
  inherit (clib)
  mkStrOption
  mkSubmoduleOption;
in {
  options = ns.opt (mkSubmoduleOption "basic host setup" {
    hostname = mkStrOption "system hostname";
    system = mkStrOption "system";
    os = mkStrOption "os";
    users = mkOption {
      description = "users on the system";
      default = {};
      type = attrsOf (submodule {
        options = {
          admin = mkEnableOption "the user being an admin";
        };
      });
    };
  });
}
