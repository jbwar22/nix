{ config, lib, ... }:

with lib; with namespace config { home.behavior.environment = ns; }; {
  options = opt {
    enable = mkEnableOption "basic environment";
  };

  config = lib.mkIf cfg.enable {
    home.sessionVariables = {
      EDITOR = "vim";
    };
  };
}
