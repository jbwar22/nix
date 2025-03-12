{ config, lib, ... }:

with lib; with ns config ./.; {
  options = opt {
    enable = mkEnableOption "auto mount flash drives";
  };

  config = lib.mkIf cfg.enable {
    services.xserver.desktopManager.runXdgAutostartIfNone = mkDefault true;
    services.udisks2.enable = true;
  };
}
