{ config, clib, ns, ... }:

let
  inherit (ns)
  cfg
  ecfg
  eopt;
  inherit (clib)
  getAdmins
  mkDisableOption
  setUserGroups;
  admins = getAdmins config.custom.common.opts.host.users;
in {
  options = eopt {
    enableService = mkDisableOption "fwupd service";
  };
  config = ecfg {
    services.fwupd.enable = true;
    users = setUserGroups admins [ "input" ];
    systemd.timers.fwupd-refresh.enable = cfg.enableService;
  };
}
