{ config, lib, pkgs, ...}:

with lib; mkNsEnableModule config ./. {
  systemd.services.journal-vacuum = {
    description = "vacuum journal, keep 2 weeks";
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.systemd}/bin/journalctl --vacuum-time=14d";
    };
    wantedBy = [ "multi-user.target" ];
  };
}
