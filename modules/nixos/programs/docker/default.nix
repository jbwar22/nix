{ config, lib, ... }:

with lib; mkNsEnableModule config ./. (let
  admins = getAdmins config.custom.common.opts.host.users;
  hasBtrfsRoot = config.fileSystems."/".fsType == "btrfs";
in {
  virtualisation.docker = {
    enable = true;
    storageDriver = mkIf hasBtrfsRoot "btrfs";
  };

  users = setUserGroups admins [ "docker" ];

  # custom.nixos.behavior.impermanence.dirs = [ "/var/lib/docker" ];
})
