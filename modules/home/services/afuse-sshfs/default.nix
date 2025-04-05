{ config, lib, pkgs, ... }:

with lib; mkNsEnableModule config ./. {
  systemd.user.enable = mkDefault true;

  systemd.user.services.afuse-sshfs = {
    Unit = {
      Description="afuse sshfs";
      AssertPathExists="%h/sshfs/";
      Requires = [ "agenix.service" ];
    };
    Service = {
      Restart="always";
      ExecStart = pkgs.writeShellScript "afuse-sshfs" ''
        ${pkgs.afuse}/bin/afuse \
        -o timeout=300 \
        -o auto_unmount \
        -o flushwrites \
        -o mount_template="${pkgs.sshfs}/bin/sshfs %r:/ %m" \
        -o unmount_template="fusermount -u -z %m" \
        -o populate_root_command="${pkgs.coreutils}/bin/cat ${ageOrDefault config "afuse-sshfs-hosts" "localhost"}" \
        -f \
        ~/sshfs
      '';
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
