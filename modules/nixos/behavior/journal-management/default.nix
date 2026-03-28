{ config, lib, pkgs, ns, ...}:

with lib; ns.enable {
  systemd.services.journal-vacuum = {
    description = "vacuum journal, keep 2 weeks";
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.systemd}/bin/journalctl --vacuum-time=14d";
    };
    wantedBy = [ "multi-user.target" ];
  };
}
