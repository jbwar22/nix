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
        skip-wait-online.enable = true;
        grub-boot.enable = true;
        virtualisation.enable = true;
        kernel-latest.enable = true;
        wake-on-lan.enable = true;
        vpn-namespace.enable = true;
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

    networking.hostName = "monstro";

    system.stateVersion = "24.05";
  };
}
