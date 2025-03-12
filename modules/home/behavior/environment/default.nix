{ config, lib, ... }:

with lib; with ns config ./.; {
  options = opt {
    enable = mkEnableOption "basic environment";
  };

  config = lib.mkIf cfg.enable {
    home.sessionVariables = {
      EDITOR = "vim";
    };
  };
}
