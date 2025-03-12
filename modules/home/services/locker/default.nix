{ config, lib, pkgs, ... }:

with lib; with ns config ./.; {
  options = opt {
    enable = mkEnableOption "locker";
  };

  config = mkIf cfg.enable {
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
  };
}
