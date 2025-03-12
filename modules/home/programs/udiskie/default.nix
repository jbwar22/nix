{ config, lib, ... }:

with lib; with ns config ./.; {
  options = opt {
    enable = mkEnableOption "udiskie";
  };

  config = mkIf cfg.enable {
    services.udiskie.enable = true;
  };
}
