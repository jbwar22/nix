{ inputs, config, lib, clib, pkgs, ns, ... }:

with lib; with ns; (let
  users = config.custom.common.opts.host.users;
  usernames = (attrNames users) ++ [ "root" ];
in {
  options = with clib; eopt {
    device = mkStrOption "btrfs device";
    mntOptions = mkOption {
      type = with types; listOf str;
      description = "btrfs mount options";
      default = [];
    };
    subvol = mkStrOption "btrfs subvol";
    paths = mkOption {
      type = with types; listOf anything;
      default = [];
    };
  };
  config = mkIf cfg.enable {
    environment.impermanence-subvolumes = {
      enable = true;
      defaultOrigin = "back";
      devices = [
        {
          inherit (cfg) device mntOptions subvol;
          mntPoint = "/persist";
          origins = [
            {
              path = "back/root";
              label = "back";
            }
            {
              path = "local/root";
              label = "local";
            }
          ];
        }
      ];
      paths = mkMerge [
        cfg.paths
        [
          # host key, needed for agenix
          { path = "/etc/ssh"; neededForBoot = true; }
          "/var/lib/nixos"
          "/var/lib/systemd/coredump"
          { path = "/var/log"; origin = "local"; }
        ]
      ];
    };

    # might not be needed
    programs.fuse.userAllowOther = mkDefault true;

    environment.etc."machine-id".source = "/persist/back/other/machine-id";

    # could persist /var/db/sudo/lectured, but meh
    custom.nixos.programs.sudo.lecture = "never";
    users.mutableUsers = mkDefault false;
    users.users = genAttrs usernames (user: {
      hashedPasswordFile = mkDefault "/persist/back/passwords/user/${user}";
    });

    nix.settings.build-dir = "/persist/local/build";

    environment.systemPackages = let
      is-pkgs = inputs.impermanence-subvolumes.packages.${pkgs.stdenv.hostPlatform.system};
    in [
      (is-pkgs.impermanence-check.override { inherit config; })
    ];
  };
})
