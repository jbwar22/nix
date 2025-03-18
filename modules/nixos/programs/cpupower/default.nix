{ config, lib, pkgs, ... }:

with lib; with ns config ./.; let
  admins = getAdmins config.custom.common.opts.host.users;
in {
  options = opt {
    enable = mkEnableOption "cpupower";
  };

  config = lib.mkIf cfg.enable ({
    environment.systemPackages = [ config.boot.kernelPackages.cpupower ];
  } // (setHMOpt admins {
    custom.home.programs.sway.shortcuts.admin.cpupower = {
      performance = pkgs.sway-kitty-popup-admin "shortcuts-admin-cpupower-performance" ''
        sudo cpupower frequency-set -g performance
      '';
    };
  }));
}
