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
    paths = mkOption {
      type = with types; listOf (coercedTo str (x:
        if typeOf x == "string" then {
          path = x;
        } else x
      ) (submodule {
        options = {
          path = mkStrOption "path";
          file = mkEnableOption "is the path a file rather than a dir";
          local = mkEnableOption "should the path live in /persist/local/root";
          neededForBoot = mkEnableOption "needed in early stages";
        };
      }));
      description = "extra paths to persist";
      default = [];
    };
  };
  config = let
    userConfs = (getHMOptWithUsername config (hmconfig: username: {
      inherit username;
      paths = hmconfig.custom.home.behavior.impermanence.paths;
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

        (pipe cfg.paths [
          (map (path: {
            name = path.path;
            value = let
              prefix = if path.local then "local" else "back";
            in if path.file then {
              device = "/persist/${prefix}/root${path.path}";
              depends = [ "/persist" ];
              neededForBoot = path.neededForBoot;
              options = [ "bind" ];
            } else {
              device = cfg.device;
              fsType = "btrfs";
              neededForBoot = path.neededForBoot;
              options = cfg.mntOptions ++ [ "subvol=${prefix}/root${path.path}" ];
            };
          }))
          listToAttrs
        ])
      ];

      # make sure home folder mountpoint parent folders have correct permissions
      custom.nixos.behavior.tmpfiles = pipe userConfs [
        (map (userConf: pipe (userConf.paths) [
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
      paths = mkMerge [
        [
          # host key, needed for agenix
          { path = "/etc/ssh"; neededForBoot = true; }
          "/var/lib/nixos"
          "/var/lib/systemd/coredump"
          { path = "/var/log"; local = true; }
        ]
        (mkMerge (map (userConf: 
          map (x: {
            inherit (x) file local neededForBoot;
            path = "/home/${userConf.username}/${x.path}";
          }) userConf.paths
        ) userConfs))
      ];
    })
  ];
})
