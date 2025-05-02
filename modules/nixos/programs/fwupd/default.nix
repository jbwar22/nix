{ config, lib, ... }:

with lib; mkNsEnableModule config ./. (let
  admins = getAdmins config.custom.common.opts.host.users;
in {
  services.fwupd.enable = true;

  users = setUserGroups admins [ "input" ];
})
