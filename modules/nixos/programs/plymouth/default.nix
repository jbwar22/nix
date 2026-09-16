{ lib, pkgs, ns, ... }:

{
  options = ns.eopt {
    theme = lib.mkOption {
      type = lib.types.str;
      default = "red_loader";
      description = "which adi1090x-plymouth-themes theme to use";
    };
  };

  config = ns.ecfg {
    boot.kernelParams = [ "quiet" ];
    boot.initrd.systemd.enable = true;
    boot.plymouth = rec {
      enable = true;
      theme = ns.cfg.theme;
      themePackages = [
        (pkgs.adi1090x-plymouth-themes.override {
          selected_themes = [ theme ];
        })
      ];
    };
  };
}
