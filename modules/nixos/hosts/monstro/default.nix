{ inputs, config, lib, ... }:

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

      programs = {
        plymouth.theme = "rings";
        snapserver.enable = true;
        virt-manager.enable = true;
      };

      behavior = {
        skip-wait-online.enable = true;
        grub-boot.enable = true;
      };
    };

    networking.hostName = "monstro";

    system.stateVersion = "24.05";

    programs.bash.shellAliases = {
      getAgeTest = "echo ${config.age.secrets.agetest.path}";
    };
  };
}
