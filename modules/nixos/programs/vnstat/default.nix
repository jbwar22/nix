{ config, lib, ... }:

with lib; with ns config ./.; {
  options = opt {
    enable = mkEnableOption "vnstat";
  };

  config = lib.mkIf cfg.enable {

    services.vnstat.enable = true;

  };
}
