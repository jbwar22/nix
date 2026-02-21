{ config, lib, ... }:

with lib; with ns config ./.; (let
  users = config.custom.common.opts.host.users;
  usernames = (attrNames users) ++ [ "root" ];
in {
  options = opt {
    enable = mkEnableOption "impermanence";
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
    custom.nixos.behavior.impermanence-subvolumes = {
      enable = true;
      inherit (cfg) paths;
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
    };

    environment.etc."machine-id".source = "/persist/back/other/machine-id";

    # could persist /var/db/sudo/lectured, but meh
    custom.nixos.programs.sudo.lecture = "never";
    users.mutableUsers = mkDefault false;
    users.users = genAttrs usernames (user: {
      hashedPasswordFile = mkDefault "/persist/back/passwords/user/${user}";
    });

    nix.settings.build-dir = "/persist/local/build";
  };
})
