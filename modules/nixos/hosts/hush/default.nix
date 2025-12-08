{ inputs, lib, ... }:

with lib; {
  imports = [
    inputs.nixos-hardware.nixosModules.framework-amd-ai-300-series
  ];

  config = {
    custom.nixos = {
      suites = {
        hardware.framework-13.enable = true;
        pc.enable = true;
        laptop.enable = true;
        gaming.enable = true;
        work.enable = true;
      };

      behavior = {
        skip-wait-online.enable = true;
        systemd-boot.enable = true;
        systemd-boot.fixResolution = true;
        secure-boot.enable = true;
        kernel-latest.enable = true;
        virtualisation.enable = true;
        etc-nixos-symlink.enable = true;
        impermanence = {
          enable = true;
        };
        tpm.enable = true;
        remote-unlock = {
          enable = true;
          authorizedKeys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCirJ2siQwyzwawQlL5VSdXdgNUI9As4OzTB99rPWYDZgGrZVWelk57Ekf+8wXJo8tBm5x+LM/2Qjs2krvvdWvqyoytl0bY78OsFb7VgOo1oRuMPnLFrQCKl9tPfzBTd6AMJB7cbe1ioxRvDOSn95PK308oWezW7YGJU8jHNu75leEDiF5PSkF21mGTT0q7coj/N6fdc461MIIJUh/hPxjeh1o6YKZuTcFSuAq0k1r9FrREaye5+tio33hhsgJFwJ/AygeYLnTFdWhPu3UArkyqAKV6y+rQo/rkO7f73FZlg8Pd/3w8GX7e1dQxamH1japdSpSzRcgzazY+/80NlEIM5jQvmNy2HW+S+WwDgkCCLhHXiCi1GOUcRbeQZBVG+gpF0VJ+ISU1Rfr6JNtdkKO/OJXSfav5grIDM3gtc7nvstXrrCNkT+fi8+LTgx/lPCpi9rYYeWCHxOdS/XEPEs/IO3P6wkeS8AOmkORYEOdOC8r3ZssWBYhWzjxeZAfeBjM= jackson@monstro" ];
          encryptedFilesDir = "/persist/initrd";
          ethernetKernelModules = [ "r8152" ];
          tpmRegister = "0x81000005";
        };
      };

      programs = {
        fwupd.enable = true;
        plymouth.theme = "rings";
        snapserver.enable = false;
        librepods.enable = true;
      };
    };

    # TODO move this!
    custom.common.opts.hardware.configLocation = "/home/jackson/documents/nixos-config";

    networking.hostName = "hush";

    system.stateVersion = "24.11";
  };
}
