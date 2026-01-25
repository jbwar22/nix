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
    dirs = mkOption {
      type = with types; listOf str;
      description = "extra dirs to persist, back";
      default = [];
    };
    dirsLocal = mkOption {
      type = with types; listOf str;
      description = "extra dirs to persist, local";
      default = [];
    };
    files = mkOption {
      type = with types; listOf str;
      description = "extra files to persist, back";
      default = [];
    };
    filesLocal = mkOption {
      type = with types; listOf str;
      description = "extra files to persist, local";
      default = [];
    };
  };
  config = let
    userConfs = (getHMOptWithUsername config (hmconfig: username: {
      inherit username;
      dirs = hmconfig.custom.home.behavior.impermanence.dirs;
      dirsLocal = hmconfig.custom.home.behavior.impermanence.dirsLocal;
      files = hmconfig.custom.home.behavior.impermanence.files;
      filesLocal = hmconfig.custom.home.behavior.impermanence.filesLocal;
    }) users);
  in mkMerge [
    (mkIf cfg.enable {
      environment.etc."machine-id".source = "/persist/back/other/machine-id";

      # could persist /var/db/sudo/lectured, but meh
      custom.nixos.programs.sudo.lecture = "never";
      users.mutableUsers = mkDefault false;
      users.users = genAttrs usernames (user: {
        hashedPasswordFile = mkDefault "/persist/back/passwords/user/${user}";
      });

      programs.fuse.userAllowOther = mkDefault true;

      fileSystems = mkMerge [
        {
          "/persist" = {
            device = cfg.device;
            fsType = "btrfs";
            neededForBoot = true; # so hashedPasswordFile can be read
            options = cfg.mntOptions ++ [ "subvol=/" ];
          };
        }
        (genAttrs cfg.dirs (dir: {
          device = cfg.device;
          fsType = "btrfs";
          options = cfg.mntOptions ++ [ "subvol=back/root${dir}" ];
        }))
        (genAttrs cfg.dirsLocal (dir: {
          device = cfg.device;
          fsType = "btrfs";
          options = cfg.mntOptions ++ [ "subvol=local/root${dir}" ];
        }))
        (genAttrs cfg.files (file: {
          device = "/persist/back/root${file}";
          depends = [ "/persist" ];
          neededForBoot = true;
          options = [ "bind" ];
        }))
        (genAttrs cfg.filesLocal (file: {
          device = "/persist/local/root${file}";
          depends = [ "/persist" ];
          neededForBoot = true;
          options = [ "bind" ];
        }))
      ];

      # make sure home folder mountpoint parent folders have correct permissions
      custom.nixos.behavior.tmpfiles = pipe userConfs [
        (map (userConf: pipe (userConf.dirs ++ userConf.dirsLocal ++ userConf.files ++ userConf.filesLocal) [
          (map (splitString "/"))
          (map (dropEnd 1))
          (map (foldl (acc: x: if (acc == []) then [x] else (
            acc ++ ["${last acc}/${x}"]
          )) []))
          flatten
          unique
          (map (x: "/home/${userConf.username}/${x}"))
          (map (x: {
            name = x;
            value = {
              type = "d";
              path = x;
              mode = "0755";
              user = userConf.username;
              group = "users";
              age = "-";
              argument = "-";
            };
          }))
        ]))
        flatten
        listToAttrs
      ];

      nix.settings.build-dir = "/persist/local/build";
    })
    (opt {
      dirs = mkMerge [
        [
          "/etc/ssh"                  # host key, needed for agenix
          "/var/lib/nixos"
          "/var/lib/systemd/coredump"
        ]
        (mkMerge (map (userConf: 
          map (x: "/home/${userConf.username}/${x}") userConf.dirs
        ) userConfs))
      ];

      dirsLocal = mkMerge [
        [
          "/var/log"
        ]
        (mkMerge (map (userConf: 
          map (x: "/home/${userConf.username}/${x}") userConf.dirsLocal
        ) userConfs))
      ];

      files = mkMerge [
        [
        ]
        (mkMerge (map (userConf: 
          map (x: "/home/${userConf.username}/${x}") userConf.files
        ) userConfs))
      ];

      filesLocal = mkMerge [
        [
        ]
        (mkMerge (map (userConf: 
          map (x: "/home/${userConf.username}/${x}") userConf.filesLocal
        ) userConfs))
      ];
    })
  ];
})
