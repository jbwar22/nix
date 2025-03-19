{ config, lib, pkgs, ... }:

with lib; mkNsEnableModule config ./. (let
  admins = getAdmins config.custom.common.opts.host.users;
in recursiveUpdate {
  environment.systemPackages = [ config.boot.kernelPackages.cpupower ];
} (setHMOpt admins {
  custom.home.programs.sway.shortcuts.admin.cpupower = {
    performance = pkgs.sway-kitty-popup-admin "shortcuts-admin-cpupower-performance" ''
      sudo cpupower frequency-set -g performance
    '';
  };
}))
