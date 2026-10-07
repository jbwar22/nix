{ lib, pkgs, ns, ... }:

let
  inherit (ns)
  cfg
  ecfg
  eopt;
  inherit (lib)
  mkIf
  mkMerge
  mkOption;
  inherit (lib.types)
  nullOr
  str;
  inherit (pkgs)
  adi1090x-plymouth-themes;
in {
  options = eopt {
    adi1090x-theme = mkOption {
      type = nullOr str;
      default = null;
      description = "which adi1090x-plymouth-themes theme to use";
    };
  };

  config = let
    # easy to create more options
    themeMode = "adi1090x";
    themeStyle =
      if cfg.adi1090x-theme == null
      then "red_loader"
      else cfg.adi1090x-theme;
  in ecfg {
    boot.kernelParams = [ "quiet" ];
    boot.initrd.systemd.enable = true;
    boot.plymouth = mkMerge [
      {
        enable = true;
      }
      (mkIf (themeMode == "adi1090x") {
        theme = cfg.adi1090x-theme;
        themePackages = [
          (adi1090x-plymouth-themes.override {
            selected_themes = [ themeStyle ];
          })
        ];
      })
    ];
  };
}
