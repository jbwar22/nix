{ config, lib, ... }:

with lib; mkNsEnableModule config ./. (let
  initrdSystemd = config.boot.initrd.systemd.enable;
  toplevelfs = config.fileSystems."/toplevel";
  wipe = ''
    mkdir /tmp -p
    TOPLEVEL=$(mktemp -d)
    (
      mount ${toplevelfs.device} $TOPLEVEL -t btrfs -o ${concatStringsSep "," toplevelfs.options}
      trap 'umount "$TOPLEVEL"' EXIT

      btrfs subvolume delete "$TOPLEVEL/@root"
      btrfs subvolume snapshot "$TOPLEVEL/@blank" "$TOPLEVEL/@root"
    )
  '';
  devToSystemdDevice = dev: (lib.replaceStrings [ "-" "/" ] [ "\\x2d" "-" ] dev) + ".device";
in {
  boot.initrd = {
    supportedFilesystems = [ "btrfs" ];
    postDeviceCommands = mkIf (!initrdSystemd) (lib.mkBefore wipe);
    systemd.services.reset-root = mkIf initrdSystemd {
      description = "reset btrfs root to blank";
      wantedBy = [ "initrd.target" ];
      before = [ "sysroot.mount" ];
      requires = [
        (devToSystemdDevice "dev/disk/by-something/foo")
      ];
      after = [
        (devToSystemdDevice "dev/disk/by-something/foo")
      ];
      unitConfig.DefaultDependencies = "no";
      serviceConfig.Type = "oneshot";
      script = wipe;
    };
  };
})
