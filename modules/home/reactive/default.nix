{ config, lib, pkgs, ... }:

with lib; mkNsEnableModule config ./. (let
  hf = config.custom.home.opts.hostfeatures;
in {
  custom.home = {
    programs = {
      sway.shortcuts.admin = {
        firewall = mkIf hf.usesNixosFirewall {
          reset = pkgs.sway-kitty-popup-admin "shortcuts-admin-firewall-reset" ''
            sudo nixos-firewall-tool reset
          '';

          snapweb = mkIf hf.runningSnapweb (
            pkgs.sway-kitty-popup-admin "shortcuts-admin-firewall-snapweb" ''
              sudo nixos-firewall-tool open tcp 1780
            ''
          );
        };

        cpupower = mkIf hf.hasCpupower {
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

  home.packages = warnIf (!(hf.hasDialoutGroup)) "\"dialout\" group needed for arduino packages" (with pkgs; [
    arduino-cli
    arduino-ide
  ]);

  xdg.configFile."libvert/qemu.conf".text = mkIf hf.hasOvmf ''
    nvram = ["/run/libvirt/nix-ovmf/OVMF_CODE.fd:/run/libvirt/nix-ovmf/OVMF_VARS.fd"]
  '';
})
