{ config, lib, pkgs, ... }:

with lib; with ns config ./.; {
  options = with types; opt {
    enable = mkEnableOption "plymouth splash screen on boot";
    theme = mkOption {
      type = str;
      default = "red_loader";
      description = "which adi1090x-plymouth-themes theme to use";
    };
  };

  config = lib.mkIf cfg.enable {
    boot.kernelParams = [ "quiet" ];
    boot.initrd.systemd.enable = true;
    boot.plymouth = rec {
      enable = true;
      theme = cfg.theme;
      themePackages = [
        (pkgs.adi1090x-plymouth-themes.override {
          selected_themes = [ theme ];
        })
      ];
    };
  };
}
