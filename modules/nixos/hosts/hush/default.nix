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
