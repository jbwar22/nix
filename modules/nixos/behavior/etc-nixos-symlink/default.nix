{ config, lib, pkgs, ... }:

with lib; with ns config ./.; {
  options = opt (mkOption {
    type = with types; nullOr str;
    default = null;
    description = "path to symlink /etc/nixos to";
  });

  config = lib.mkIf (cfg != null) {
    environment.etc."nixos" = {
      source = myMkOutOfStoreSymlink pkgs cfg;
    };
  };
}
