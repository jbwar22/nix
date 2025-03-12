{ config, lib, ... }:

with lib; with ns config ./.; {
  options = opt {
    enable = mkEnableOption "the basic suite of nixos modules for all hosts";
  };

  config = lib.mkIf cfg.enable {
    custom.nixos = {
      behavior = {
        appimage.enable = true;
        flakes-support.enable = true;
        locale.enable = true;
        network.enable = true;
        time.enable = true;
      };

      programs = {
        noconfig.util.enable = true;
        noconfig.tui.enable = true;
        ssh.enable = true;
        tailscale.enable = true;
        vnstat.enable = true;
      };

      reactive = {
        common.enable = true;
        home.enable = true;
      };
    };
  };
}
