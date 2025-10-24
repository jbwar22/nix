{ config, lib, ... }:

with lib; with ns config ./.; (let
  admins = getAdmins config.custom.common.opts.host.users;
  hasBtrfsRoot = config.fileSystems."/".fsType == "btrfs";
in {
  options = opt {
    enable = mkEnableOption "docker";
    enableOnBoot = mkEnableOption "enable on boot";
  };
  config = mkIf cfg.enable {
    virtualisation.docker = {
      enable = true;
      storageDriver = mkIf hasBtrfsRoot "btrfs";
      enableOnBoot = cfg.enableOnBoot;
    };

    users = setUserGroups admins [ "docker" ];

    custom.nixos.behavior.impermanence.dirs = [ "/var/lib/docker" ];
  };
})
