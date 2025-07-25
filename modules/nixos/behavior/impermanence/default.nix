{ config, lib, ... }:

with lib; with ns config ./.; (let
  users = config.custom.common.opts.host.users;
  usernames = (attrNames users) ++ [ "root" ];
in {
  options = opt {
    enable = mkEnableOption "impermanence on btrfs";
    device = mkOption {
      type = types.str;
      description = "btrfs device";
    };
    mntOptions = mkOption {
      type = with types; listOf str;
      description = "btrfs mount options";
      default = [];
    };
    persist = mkOption {
      type = types.str;
      description = "persist subvol";
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
  config = mkMerge [
    (mkIf cfg.enable {
      # could persist /var/db/sudo/lectured, but meh
      custom.nixos.programs.sudo.lecture = "never";
      users.mutableUsers = mkDefault false;
      users.users = genAttrs usernames (user: {
        hashedPasswordFile = mkDefault "/persist/passwords/user/${user}"; # TODO
      });

      programs.fuse.userAllowOther = mkDefault true;

      fileSystems = mkMerge [
        {
          "/persist" = {
            device = cfg.device;
            fsType = "btrfs";
            options = cfg.mntOptions ++ [ "subvol=${cfg.persist}" ];
          };
        }
        (genAttrs cfg.dirs (dir: {
          device = cfg.device;
          fsType = "btrfs";
          options = cfg.mntOptions ++ [ "subvol=${cfg.persist}${dir}" ];
        }))
        (genAttrs cfg.files (file: {
          device = "/persist${file}";
          options = [ "bind" ];
        }))
      ];

      custom.nixos.behavior.tmpfiles = genAttrs [
        "/home/jackson/.cache"
        "/home/jackson/.config"
        "/home/jackson/.local"
        "/home/jackson/.local/share"
        "/home/jackson/.local/state"
        "/home/jackson/.mozilla"
      ] (path: {
        type = "d";
        inherit path;
        mode = "0755";
        user = "jackson";
        group = "users";
        age = "-";
        argument = "-";
      });

    })
    (opt {
      dirs = mkMerge [
        [
          "/etc/ssh"                  # host key, needed for agenix
          "/var/lib/nixos"
          "/var/lib/systemd/coredump"
          "/var/log"
        ]
        (mkMerge (pipe users [
          (getHMOptWithUsername config (hmconfig: username:
            pipe hmconfig.custom.home.behavior.impermanence.dirs [
              (map (x: "/home/${username}/${x}"))
            ]
          ))
        ]))
      ];

      files = mkMerge [
        [
          "/etc/machine-id"
          "/etc/nixos"
        ]
        (mkMerge (pipe users [
          (getHMOptWithUsername config (hmconfig: username:
            pipe hmconfig.custom.home.behavior.impermanence.files [
              (map (x: "/home/${username}/${x}"))
            ]
          ))
        ]))
      ];
    })
  ];
})
