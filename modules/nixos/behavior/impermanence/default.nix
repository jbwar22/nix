{ config, lib, pkgs, ... }:

with lib; with ns config ./.; (let
  users = (attrNames config.custom.common.opts.host.users) ++ [ "root" ];
  toplevelfs = config.fileSystems."/toplevel";
in {
  options = opt {
    enable = mkEnableOption "impermanence on btrfs";
    nixconfigSymlink = mkOption {
      type = with types; nullOr path;
      description = "what to link /etc/nixos to, if anything";
      default = null;
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
        plymouth display-message --text="Skipping wipe root"
      '';
    };

    boot.initrd = {
      supportedFilesystems = [ "btrfs" ];
      systemd = {
        enable = mkDefault true;
        storePaths = with pkgs; [
          "${btrfs-progs}/bin/btrfs"
          "${coreutils}/bin/cp"
          "${coreutils}/bin/cut"
          "${coreutils}/bin/date"
          "${coreutils}/bin/dirname"
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

          path = with pkgs; [
            btrfs-progs
            coreutils
            findutils
            plymouth
            util-linux
          ];

          script = let
            copy_dirs = pipe cfg.dirs [
              (sort (p: q: (stringLength p) < (stringLength q)))
              (map (x: "\"${x}\""))
              (concatStringsSep " ")
              (x: "copy_dirs=(${x})")
            ];
            copy_files = pipe cfg.files [
              (sort (p: q: (stringLength p) < (stringLength q)))
              (map (x: "\"${x}\""))
              (concatStringsSep " ")
              (x: "copy_files=(${x})")
            ];
            log = message: if true then "plymouth display-message --text=\"[impermanence-btrfs] ${message}\"" else "";
          in ''
            ${copy_dirs}
            ${copy_files}

            ${log "mounting"}
            mkdir /toplevel
            mount ${toplevelfs.device} /toplevel -t btrfs -o ${concatStringsSep "," toplevelfs.options}

            timestamp=$(date --date="@$(stat -c %Y /toplevel/@root)" "+@root@%Y-%m-%d-%H:%M:%S")

            ${log "creating new root subvolume"}
            mv /toplevel/@root /toplevel/@old_root
            btrfs subvolume create /toplevel/@root

            copy_subvolume_recursively() {
              if [ $(stat --format=%i "$2") -eq 2 ]; then
                btrfs subvolume delete "$2"
              fi
              mkdir -p $(dirname "$2")
              btrfs subvolume snapshot "$1" "$2"
              IFS=$'\n'
              for subvolume in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
                new_subvolume="$(echo "$subvolume" | cut -c 11-)"
                copy_subvolume_recursively "/toplevel/$subvolume" "/toplevel/@root/$new_subvolume"
              done
            }

            for dir in "$${copy_dirs[@]}"; do
              mkdir -p $(dirname "/toplevel/@root$dir")
              if [ ! -e "/toplevel/@old_root$dir" ]; then
                ${log "creating new subvolume: $dir"}
                btrfs subvolume create "/toplevel/@root$dir"
              elif [ $(stat --format=%i "/toplevel/@old_root$dir") -eq 256 ]; then
                ${log "snapshotting: $dir"}
                copy_subvolume_recursively "/toplevel/@old_root$dir" "/toplevel/@root$dir"
              else
                ${log "copying to new subvolume: $dir"}
                btrfs subvolume create "/toplevel/@root$dir"
                cp -a "/toplevel/@old_root$dir" "/toplevel/@root$dir"
              fi
            done

            for file in "$${copy_files[@]}"; do
              ${log "copying file: $file"}
              mkdir -p $(dirname "/toplevel/@root$file")
              cp -a "/toplevel/@old_root$file" "/toplevel/@root$file"
            done

            ${log "backing up old root"}
            mkdir -p /toplevel/old_roots
            mv "/toplevel/@old_root" "/toplevel/old_roots/$timestamp"

            delete_subvolume_recursively() {
              IFS=$'\n'
              for subvolume in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
                delete_subvolume_recursively "/toplevel/$subvolume"
              done
              btrfs subvolume delete "$subvolume"
            }

            for old_root in $(find /toplevel/old_roots/ -maxdepth 1 -mtime +30); do
              ${log "pruning old root: $old_root"}
              delete_subvolume_recursively "$old_root"
            done

            umount /toplevel
            ${log "complete"}
          '';
        };
      };
    };

    cfg.dirs = [
      "/etc/ssh"                  # host key, needed for agenix
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/var/log"
    ];

    cfg.files = [
      "/etc/machine-id"
      "/etc/nixos"
    ];

    # could persist /var/db/sudo/lectured, but meh
    custom.nixos.programs.sudo.lecture = "never";

    environment.etc."nixos".source = mkIf (cfg.nixconfigSymlink != null) (myMkOutOfStoreSymlink pkgs cfg.nixconfigSymlink);

    users.mutableUsers = mkDefault false;
    users.users = genAttrs users (user: {
      hashedPasswordFile = mkDefault "/persist/passwords/user/${user}"; # TODO
    });

    programs.fuse.userAllowOther = mkDefault true;
  };
})
