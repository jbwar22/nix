{ config, lib, ... }:

with lib; with ns config ./.; {
  options = opt {
    enable = mkEnableOption "required system options for home swaylock";
  };
  config = lib.mkIf cfg.enable {
    security.pam.services.swaylock = {};
    security.polkit.enable = mkDefault true;
  };
}
