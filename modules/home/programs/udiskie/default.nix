{ config, lib, ... }:

with lib; with namespace config { home.programs.udiskie = ns; }; {
  options = opt {
    enable = mkEnableOption "udiskie";
  };

  config = mkIf cfg.enable {
    services.udiskie.enable = true;
  };
}
