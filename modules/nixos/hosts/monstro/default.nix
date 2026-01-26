{ inputs, lib, ... }:

with lib; {
  imports = [
    inputs.nixos-hardware.nixosModules.gigabyte-b550
  ];

  config = {
    custom.nixos = {
      opts = {
        secrets = {
          timeZone = trim (readFile ../../../../secrets/git-crypt/strings/timezone-monstro.txt);
        };
      };

      suites = {
        hardware.gigabyte-b550i.enable = true;

        pc.enable = true;
        gaming.enable = true;
      };

      behavior = {
        systemd-boot.enable = true;
        systemd-boot.fixResolution = true;
        secure-boot.enable = true;
        impermanence = {
          enable = true;
        };
        etc-nixos-symlink.enable = true;
        virtualisation.enable = true;
        kernel-latest.enable = true;
        wake-on-lan.enable = true;
        vpn-namespace.enable = true;
        tpm.enable = true;
        pipewire-low-latency.enable = true;
      };

      programs = {
        plymouth.theme = "rings";
        snapserver.enable = true;
        tailscale.serviceContainer = {
          enable = true;
          volumesRoot = "/home/jackson/documents/docker/tailscale-services";
        };
        # sunshine.enable = true;
      };
    };

    # TODO move this!
    custom.common.opts.hardware.configLocation = "/home/jackson/documents/nixos-config";

    networking.hostName = "monstro";

    system.stateVersion = "24.05";
  };
}
