{ config, lib, ... }:

with lib; with namespace config { nixos.suites.pc = ns; }; {
  options = opt {
    enable = mkEnableOption "suite of nixos modules for pc hosts";
  };

  config = lib.mkIf cfg.enable {
    custom.nixos = {
      behavior = {
        bluetooth.enable = true;
        graphics.enable = true;
        ios-mount.enable = true;
        printing.enable = true;
        sound.enable = true;
      };

      programs = {
        noconfig.vpn.enable = true;
        docker.enable = true;
        flatpak.enable = true;
        plymouth.enable = true;
        udiskie.enable = true;
      };
    };
  };
}
