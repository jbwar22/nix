{ config, lib, ... }:

with lib;
let
  inherit (namespace config { home.behavior.environment = ns; }) cfg opt;
in
{
  options = opt {
    enable = mkEnableOption "basic environment";
  };

  config = lib.mkIf cfg.enable {
    home.sessionVariables = {
      EDITOR = "vim";
    };
  };
}
