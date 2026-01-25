{ config, lib, pkgs, ... }:

with lib; mkNsEnableModule config ./. (let
  null-tz = config.time.timeZone == null;
  imper-e = config.custom.nixos.behavior.impermanence.enable;
in {
  services.ntp.enable = true;
  time.timeZone = config.custom.nixos.opts.secrets.timeZone;

  custom.nixos.behavior.impermanence.files = mkIf null-tz [ "/etc/localtime" ];

  # timedatectl complains when /etc/localtime is a bind mount or otherwise can't be overwritten
  # as a fix, we only care about the bind mount at boot. As long as both are updated it's fine
  environment.systemPackages = mkIf (null-tz && imper-e) (with pkgs; [
    (writeShellScriptBin "set-timezone" ''
      sudo umount -q /etc/localtime
      sudo rm /etc/localtime
      sudo timedatectl set-timezone $1
      cat /etc/localtime | sudo tee /persist/back/root/etc/localtime > /dev/null
    '')
  ]);
})
