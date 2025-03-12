{ config, lib, ... }:

with lib; with ns config ./.; {
  options = opt {
    enable = mkEnableOption "required system options for home fcitx5";
  };

  config = lib.mkIf cfg.enable {
    services.xserver.desktopManager.runXdgAutostartIfNone = mkDefault true;
  };
}
