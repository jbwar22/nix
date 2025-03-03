{ config, lib, ... }:

with lib;
let
  inherit (namespace config { home.programs.udiskie = ns; }) cfg opt;
in
{
  options = opt {
    enable = mkEnableOption "udiskie";
  };

  config = mkIf cfg.enable {
    services.udiskie.enable = true;
  };
}
