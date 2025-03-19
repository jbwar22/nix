{ config, lib, pkgs, ... }:

with lib; mkNsEnableModule config ./. (let
  admins = getAdmins config.custom.common.opts.host.users;
in recursiveUpdate {
  # firewall is on by default, this is for extra stuff related to it
} (setHMOpt admins {
  custom.home.programs.sway.shortcuts.admin.firewall = {
    reset = pkgs.sway-kitty-popup-admin "shortcuts-admin-firewall-reset" ''
      sudo nixos-firewall-tool reset
    '';
  };
}))
