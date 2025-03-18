{ config, lib, pkgs, ... }:

with lib; with ns config ./.; let
  admins = getAdmins config.custom.common.opts.host.users;
in {
  options = opt {
    enable = mkEnableOption "firewall related options";
  };
  config = lib.mkIf cfg.enable ({
    # firewall is on by default, this is for extra stuff related to it
  } // (setHMOpt admins {
    custom.home.programs.sway.shortcuts.admin.firewall = {
      reset = pkgs.sway-kitty-popup-admin "shortcuts-admin-firewall-reset" ''
        sudo nixos-firewall-tool reset
      '';
    };
  }));
}
