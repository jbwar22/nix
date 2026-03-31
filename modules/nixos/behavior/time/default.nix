{ config, lib, clib, pkgs, ns, ... }:

with lib; ns.enable (let
  null-tz = config.time.timeZone == null;
  imper-e = config.custom.nixos.behavior.impermanence.enable;
in {
  services.ntp.enable = true;
  time.timeZone = config.custom.nixos.opts.secrets.timeZone;

  custom.nixos.behavior.impermanence.paths = mkIf null-tz [
    { path = "/etc/localtime"; file = true; }
  ];

  # timedatectl complains when /etc/localtime is a bind mount or otherwise can't be overwritten
  # as a fix, we only care about the bind mount at boot. As long as both are updated it's fine
  environment.systemPackages = mkIf null-tz (clib.mkIfElse imper-e [(pkgs.writeShellScriptBin "set-timezone" ''
      sudo umount -q /etc/localtime
      sudo rm /etc/localtime
      sudo timedatectl set-timezone $1
      cat /etc/localtime | sudo tee /persist/back/root/etc/localtime > /dev/null
  '')] [(pkgs.writeShellScriptBin "set-timezone" ''
      sudo timedatectl set-timezone $1
  '')]);
})
