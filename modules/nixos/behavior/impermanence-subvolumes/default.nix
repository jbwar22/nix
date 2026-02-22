{ config, lib, ... }:

with lib; with ns config ./.; {
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
    userConfs = if (hasAttr "home-manager" config) then pipe config.home-manager.users [
      attrsToList
      (filter (user: hasAttr "impermanence-subvolumes" user.value.custom.home.behavior))
      (filter (user: user.value.custom.home.behavior.impermanence-subvolumes.enable))
      (map (user: {
        username = user.name;
        paths = user.value.custom.home.behavior.impermanence-subvolumes.paths;
      }))
    ] else [];
  in mkMerge [
    (mkIf cfg.enable {
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
      systemd.tmpfiles.rules = pipe userConfs [
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
          (map (x: "d ${x} 0755 ${userConf.username} users - -"))
        ]))
        flatten
      ];
    })
    (opt {
      paths = (mkMerge (map (userConf: 
        map (x: {
          inherit (x) file neededForBoot;
          origin = mkIf (x.origin != null) x.origin;
          path = "/home/${userConf.username}/${x.path}";
        }) userConf.paths
      ) userConfs));
    })
  ];
}
