{ config, lib, pkgs, ... }:

with lib; mkNsEnableModule config ./. (let
  admins = getAdmins config.custom.common.opts.host.users;
in recursiveUpdate {
  users = setUserGroups admins [ "dialout" ];
} (setHMOpt admins {
  home.packages = with pkgs; [
    arduino-cli
    arduino-ide
  ];
}))
