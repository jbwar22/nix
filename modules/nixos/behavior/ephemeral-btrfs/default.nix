{ config, lib, ... }:

with lib; mkNsEnableModule config ./. (let
  toplevelfs = config.fileSystems."/toplevel";
  wipe = ''
    mkdir -p /tmp 
    TOPLEVEL=$(mktemp -d)
    (
      mount ${toplevelfs.device} $TOPLEVEL -t btrfs -o ${concatStringsSep "," toplevelfs.options}
      trap 'umount "$TOPLEVEL"' EXIT

      # maybe sort by length?
      for subvolume in $(btrfs subvolume list -o $TOPLEVEL/@root | cut -f9 -d' '); do
        echo "deleting subvolume: $subvolume"
        btrfs subvolume delete "$TOPLEVEL/$subvolume"
      done

      if [ $? -eq 0 ]; then
        btrfs subvolume delete "$TOPLEVEL/@root"
        btrfs subvolume snapshot "$TOPLEVEL/@blank" "$TOPLEVEL/@root"
      else
        echo "failed deleting children subvolumes of @root"
        exit 1
      fi
    )
  '';
  # devToSystemdDevice = dev: (lib.replaceStrings [ "-" "/" ] [ "\\x2d" "-" ] dev) + ".device";
  # (devToSystemdDevice "dev/disk/by-something/foo")
in {
  boot.initrd = {
    supportedFilesystems = [ "btrfs" ];
    systemd = {
      enable = true;
      storePaths = with pkgs; [
        "${util-linux}/bin/mount"
        "${util-linux}/bin/umount"
        "${btrfs-progs}/bin/btrfs"
        "${coreutils}/bin/cut"
      ];

      services.reset-root = {
        description = "reset btrfs root to blank";

        wantedBy = [ "sysinit.target" ];

        before = [ "local-fs-pre.target" ];
        after = [ "cryptsetup.target" ];

        unitConfig.DefaultDependencies = "no";
        serviceConfig.Type = "oneshot";

        script = wipe;

        path = with pkgs; [
          util-linux
          btrfs-progs
          coreutils
        ];
      };
    };
  };
})
