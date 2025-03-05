{ config, lib, ... }:

with lib; with namespace config { common.opts.host = ns; }; {
  options = opt (mkSubmoduleOption "basic host setup" {
    hostname = mkStrOption "system hostname";
    system = mkStrOption "system";
    os = mkStrOption "os";
    users = mkOption {
      description = "users on the system";
      default = {};
      type = with types; attrsOf (submodule {
        options = {
          admin = mkEnableOption "the user being an admin";
        };
      });
    };
  });
}
