{ config, lib, ... }:

with lib; {
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
      virt-manager.enable = true;
    };

    behavior = {
      skip-wait-online.enable = true;
      grub-boot.enable = true;
    };
  };

  networking.hostName = "monstro";

  system.stateVersion = "24.05";

  age = {
    secrets = {
      agetest.file = ../../../../secrets/agenix/hosts/monstro/agetest.age;
    };
  };

  programs.bash.shellAliases = {
    getAgeTest = "echo ${config.age.secrets.agetest.path}";
  };
}
