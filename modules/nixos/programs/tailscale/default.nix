{ config, lib, ... }:

with lib; mkNsEnableModule config ./. (let
  admins = getAdmins config.custom.common.opts.host.users;
in {
  services.tailscale.enable = true;

  services.davfs2 = {
    enable = true;
  };

  users = setUserGroups admins [ "davfs2" ];

  environment.persistence = persistSysDirs config [ "/var/lib/tailscale" ];
})
