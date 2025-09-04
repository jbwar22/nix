{ config, lib, ... }:

with lib; with ns config ./.; (let
  admins = getAdmins config.custom.common.opts.host.users;
in {
  options = opt {
    enable = mkEnableOption "fwupd";
    enableService = mkDisableOption "fwupd service";
  };
  config = mkIf cfg.enable {
    services.fwupd.enable = true;
    users = setUserGroups admins [ "input" ];
    systemd.timers.fwupd-refresh.enable = cfg.enableService;
  };
})
