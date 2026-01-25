{ config, lib, ... }:

with lib; with ns config ./.; (let
  users = config.custom.common.opts.host.users;
  usernames = (attrNames users) ++ [ "root" ];

  impermanentPathType = types.submodule {
    options = {
      path = mkStrOption "path";
      local = mkEnableOption "should the path live in /persist/local/root";
      neededForBoot = mkEnableOption "needed in early stages";
    };
  };
  impermanentOptType = with types; listOf (coercedTo str (x:
    if typeOf x == "string" then {
      path = x;
    } else x
  ) impermanentPathType);
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
      type = impermanentOptType;
      description = "extra dirs to persist";
      default = [];
    };

    files = mkOption {
      type = impermanentOptType;
      description = "extra dirs to persist";
      default = [];
    };
  };
  config = let
    userConfs = (getHMOptWithUsername config (hmconfig: username: {
      inherit username;
      dirs = hmconfig.custom.home.behavior.impermanence.dirs;
      files = hmconfig.custom.home.behavior.impermanence.files;
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

        (pipe cfg.dirs [
          (map (dir: {
            name = dir.path;
            value = let
              prefix = if dir.local then "local" else "back";
            in {
              device = cfg.device;
              fsType = "btrfs";
              neededForBoot = dir.neededForBoot;
              options = cfg.mntOptions ++ [ "subvol=${prefix}/root${dir.path}" ];
            };
          }))
          listToAttrs
        ])

        (pipe cfg.files [
          (map (file: {
            name = file.path;
            value = let
              prefix = if file.local then "local" else "back";
            in {
              device = "/persist/${prefix}/root${file.path}";
              depends = [ "/persist" ];
              neededForBoot = file.neededForBoot;
              options = [ "bind" ];
            };
          }))
          listToAttrs
        ])
      ];

      # make sure home folder mountpoint parent folders have correct permissions
      custom.nixos.behavior.tmpfiles = pipe userConfs [
        (map (userConf: pipe (userConf.dirs ++ userConf.files) [
          (map (x: x.path))
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
          # host key, needed for agenix
          { path = "/etc/ssh"; neededForBoot = true; }
          "/var/lib/nixos"
          "/var/lib/systemd/coredump"
          { path = "/var/log"; local = true; }
        ]
        (mkMerge (map (userConf: 
          map (x: {
            inherit (x) local neededForBoot;
            path = "/home/${userConf.username}/${x.path}";
          }) userConf.dirs
        ) userConfs))
      ];

      files = mkMerge [
        [ ]
        (mkMerge (map (userConf: 
          map (x: {
            inherit (x) local neededForBoot;
            path = "/home/${userConf.username}/${x.path}";
          }) userConf.files
        ) userConfs))
      ];
    })
  ];
})
