{ config, lib, pkgs, ... }:

with lib; with ns config ./.; (let
  users = (attrNames config.custom.common.opts.host.users) ++ [ "root" ];
  toplevelfs = config.fileSystems."/toplevel";
  wipe = ''
    plymouth display-message --text="Wiping root subvolume..."
    mkdir /toplevel
    mount ${toplevelfs.device} /toplevel -t btrfs -o ${concatStringsSep "," toplevelfs.options}

    if [[ -e /toplevel/@root ]]; then
      mkdir -p /toplevel/old_roots
      timestamp=$(date --date="@$(stat -c %Y /toplevel/@root)" "+@root@%Y-%m-%d-%H:%M:%S")
      mv "/toplevel/@root" "/toplevel/old_roots/$timestamp"
    fi

    delete_subvolume_recursively() {
      IFS=$'\n'
      for subvolume in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
        delete_subvolume_recursively "/toplevel/$subvolume"
      done
      btrfs subvolume delete "$subvolume"
    }

    for old_root in $(find /toplevel/old_roots/ -maxdepth 1 -mtime +30); do
      delete_subvolume_recursively "$old_root"
    done

    btrfs subvolume create /toplevel/@root
    umount /toplevel
    plymouth display-message --text="Root wipe complete."
  '';
  # devToSystemdDevice = dev: (lib.replaceStrings [ "-" "/" ] [ "\\x2d" "-" ] dev) + ".device";
  # (devToSystemdDevice "dev/disk/by-something/foo")
in {
  options = opt {
    enable = mkEnableOption "impermanence on btrfs";
    nixconfigSymlink = mkOption {
      type = with types; nullOr path;
      description = "what to link /etc/nixos to, if anything";
      default = null;
    };
    persistPath = mkOption {
      type = with types; path;
      description = "persist path";
    };
    dirs = mkOption {
      type = with types; listOf str;
      description = "extra dirs to persist";
      default = [];
    };
    files = mkOption {
      type = with types; listOf str;
      description = "extra files to persist";
      default = [];
    };
  };
  config = mkIf cfg.enable {
    specialisation.no-wipe-root.configuration = {
      boot.initrd.systemd.services.reset-root.script = mkForce ''
        echo skipping resetting root
      '';
    };

    boot.initrd = {
      supportedFilesystems = [ "btrfs" ];
      systemd = {
        enable = mkDefault true;
        storePaths = with pkgs; [
          "${btrfs-progs}/bin/btrfs"
          "${coreutils}/bin/cut"
          "${coreutils}/bin/date"
          "${coreutils}/bin/mkdir"
          "${coreutils}/bin/mv"
          "${coreutils}/bin/stat"
          "${findutils}/bin/find"
          "${plymouth}/bin/plymouth"
          "${util-linux}/bin/mount"
          "${util-linux}/bin/umount"
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
            btrfs-progs
            coreutils
            findutils
            plymouth
            util-linux
          ];
        };
      };
    };

    environment.persistence.${cfg.persistPath} = {
      enable = true;
      hideMounts = true;
      directories = [
        "/etc/ssh"                  # host key, needed for agenix
        "/var/lib/nixos"
        "/var/lib/systemd/coredump"
        "/var/log"
      ] ++ cfg.dirs;
      files = [
        "/etc/machine-id"
      ] ++ cfg.files;
    };

    # could persist /var/db/sudo/lectured, but meh
    custom.nixos.programs.sudo.lecture = "never";

    environment.etc."nixos".source = mkIf (cfg.nixconfigSymlink != null) (myMkOutOfStoreSymlink pkgs cfg.nixconfigSymlink);

    users.mutableUsers = mkDefault false;
    users.users = genAttrs users (user: {
      hashedPasswordFile = mkDefault "/persist/passwords/user/${user}";
    });

    programs.fuse.userAllowOther = mkDefault true;
  };
})
