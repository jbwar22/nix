{ config, lib, ... }:

with lib; with ns config ./.; (let
  users = config.custom.common.opts.host.users;
  usernames = (attrNames users) ++ [ "root" ];
in {
  options = opt {
    enable = mkEnableOption "impermanence on btrfs";
    defaultOrigin = mkStrOption "default origin if unspecified";
    devices = mkOption {
      type = with types; listOf (submodule {
        options = {
          device = mkStrOption "btrfs device";
          subvol = mkStrOption "btrfs subvol";
          mntPoint = mkStrOption "mntpoint of device (needed for file fuse mounts)";
          mntOptions = mkOption {
            type = listOf str;
            description = "btrfs mount options";
            default = [];
          };
          origins = mkOption {
            description = "origins on this device";
            type = listOf (submodule {
              options = {
                path = mkStrOption "path of origin";
                label = mkStrOption "label of origin";
              };
            });
          };
        };
      });
    };
    extras = {
      machine-id.path = mkStrOption "path for machine-id";
      passwords.path = mkStrOption "path for passwords dir";
      build.path = mkStrOption "path for build dir";
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
          origin = mkOption {
            type = types.str;
            description = "origin of path";
            default = cfg.defaultOrigin;
          };
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
      environment.etc."machine-id".source = cfg.extras.machine-id.path;

      # could persist /var/db/sudo/lectured, but meh
      custom.nixos.programs.sudo.lecture = "never";
      users.mutableUsers = mkDefault false;
      users.users = genAttrs usernames (user: {
        hashedPasswordFile = mkDefault "${cfg.extras.passwords.path}/${user}";
      });

      programs.fuse.userAllowOther = mkDefault true;

      fileSystems = mkMerge [
        (pipe cfg.devices [
          (map (device: {
            name = device.mntPoint;
            value = {
              inherit (device) device;
              fsType = "btrfs";
              neededForBoot = true;
              options = device.mntOptions ++ [ "subvol=${device.subvol}" ];
            };
          }))
          listToAttrs
        ])
        (pipe cfg.paths [
          (map (path: let
            origins = pipe cfg.devices [
              (map (device: map (origin: {
                inherit (device) device mntOptions mntPoint subvol;
                inherit (origin) path label;
              }) device.origins))
              flatten
            ];
            origin = findFirst (x: x.label == path.origin) null origins;
          in {
            name = path.path;
            value = if path.file then {
              device = let
                fixedPath = if origin.path == "" then "" else "/${origin.path}";
              in "${origin.mntPoint}${fixedPath}${path.path}";
              depends = [ origin.mntPoint ];
              neededForBoot = path.neededForBoot;
              options = [ "bind" ];
            } else {
              device = origin.device;
              fsType = "btrfs";
              neededForBoot = path.neededForBoot;
              options = let
                subvolRoot = if origin.subvol == "/" then "" else "${origin.subvol}/";
              in origin.mntOptions ++ [ "subvol=${subvolRoot}${origin.path}${path.path}" ];
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

      nix.settings.build-dir = cfg.extras.build.path;
    })
    (opt {
      paths = mkMerge [
        [
          # host key, needed for agenix
          { path = "/etc/ssh"; neededForBoot = true; }
          "/var/lib/nixos"
          "/var/lib/systemd/coredump"
          { path = "/var/log"; origin = "local"; }
        ]
        (mkMerge (map (userConf: 
          map (x: {
            inherit (x) file neededForBoot;
            origin = mkIf (x.origin != null) x.origin;
            path = "/home/${userConf.username}/${x.path}";
          }) userConf.paths
        ) userConfs))
      ];
    })
  ];
})
