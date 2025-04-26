{ config, lib, pkgs, osConfig, ... }:

with lib; mkNsEnableModule config ./. {
  custom.home = {
    programs = {
      sway.shortcuts.admin = {
        firewall = mkIf osConfig.networking.firewall.enable {
          reset = pkgs.sway-kitty-popup-admin "shortcuts-admin-firewall-reset" ''
            sudo nixos-firewall-tool reset
          '';

          snapweb = mkIf osConfig.custom.nixos.programs.snapserver.enable (
            pkgs.sway-kitty-popup-admin "shortcuts-admin-firewall-snapweb" ''
              sudo nixos-firewall-tool open tcp 1780
            ''
          );
        };

        cpupower = mkIf osConfig.custom.nixos.programs.cpupower.enable {
          performance = pkgs.sway-kitty-popup-admin "shortcuts-admin-cpupower-performance" ''
            sudo cpupower frequency-set -g performance
          '';
          powersave = pkgs.sway-kitty-popup-admin "shortcuts-admin-cpupower-performance" ''
            sudo cpupower frequency-set -g powersave
          '';
        };
      };
    };
  };

  home.packages = warnIf (!(hasGroup config osConfig "dialout")) "\"dialout\" group needed for arduino packages" (with pkgs; [
    arduino-cli
    arduino-ide
  ]);

  xdg.configFile."libvert/qemu.conf".text = mkIf osConfig.virtualisation.libvirtd.qemu.ovmf.enable ''
    nvram = ["/run/libvirt/nix-ovmf/OVMF_CODE.fd:/run/libvirt/nix-ovmf/OVMF_VARS.fd"]
  '';
}
