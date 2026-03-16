{ config, lib, pkgs, ... }:

with lib; mkNsEnableModule config ./. (let
  users = config.custom.common.opts.host.users;
in {
  environment.systemPackages = with pkgs; [
    librepods
  ];

  # TODO is this needed?
  users = setUserGroups users [ "librepods" ];
})

