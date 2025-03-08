{ config, lib, ... }:

with lib; with namespace config { nixos.programs.vnstat = ns; }; {
  options = opt {
    enable = mkEnableOption "vnstat";
  };

  config = lib.mkIf cfg.enable {

    services.vnstat.enable = true;

  };
}
