{ inputs, lib, pkgs, ... }:

with lib; {
  imports = [
    inputs.nixos-hardware.nixosModules.framework-amd-ai-300-series
  ];

  config = {

    boot.loader.systemd-boot.consoleMode = "auto";

    custom.nixos = {
      opts = {
        secrets = {
          timeZone = trim (readFile ../../../../secrets/git-crypt/strings/timezone-widow.txt);
        };
      };

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
        kernel-latest.enable = true;
      };

      programs = {
        plymouth.theme = "rings";
        snapserver.enable = false;
      };
    };

    networking.hostName = "hush";

    system.stateVersion = "24.11";
  };
}
