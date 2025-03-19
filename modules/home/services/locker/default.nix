{ config, lib, pkgs, ... }:

with lib; mkNsEnableModule config ./. {
  systemd.user.services.locker = {
    Unit = {
      Description = "run locker server";
    };
    Service = {
      ExecStart = pkgs.writeShellScript "locker-script" ''
        SWAYLOCK=${pkgs.swaylock}/bin/swaylock ${pkgs.nodejs}/bin/node /home/jackson/documents/dev/locker/index.js > /tmp/locker.out
      '';
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
