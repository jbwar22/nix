{ lib, pkgs, ns, ... }:

with lib; with ns; {
  options = with types; eopt {
    theme = mkOption {
      type = str;
      default = "red_loader";
      description = "which adi1090x-plymouth-themes theme to use";
    };
  };

  config = ecfg {
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
