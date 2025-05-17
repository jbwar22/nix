{ config, lib, ... }:

with lib; mkNsEnableModule config ./. (let
  admins = getAdmins config.custom.common.opts.host.users;
in {
  virtualisation.docker = {
    enable = true;
    storageDriver = "btrfs";
  };

  users = setUserGroups admins [ "docker" ];

  # custom.nixos.behavior.impermanence.dirs = [ "/var/lib/docker" ];
})
