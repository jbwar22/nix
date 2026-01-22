{ inputs, lib, ... }:

with lib; {
  imports = [
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t480
  ];

  config = {
    custom.nixos = {
      opts = {
        secrets = {
          timeZone = trim (readFile ../../../../secrets/git-crypt/strings/timezone-widow.txt);
        };
      };

      suites = {
        hardware.lenovo-t480.enable = true;

        pc.enable = true;
        laptop.enable = true;
        gaming.enable = true;
        work.enable = true;
      };

      behavior = {
        systemd-boot.enable = true;
        systemd-boot.efiAtSlashBoot = true;
        kernel-latest.enable = true;
      };

      programs = {
        snapserver.enable = true;
      };
    };

    networking.hostName = "widow";

    system.stateVersion = "23.11";
  };
}
