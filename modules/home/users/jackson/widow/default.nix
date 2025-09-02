{ config, lib, ... }:

with lib; {
  config = {
    home.stateVersion = "23.11";

    custom.home = {
      suites = {
        pc.enable = true;
        work.enable = true;
      };

      services = {
        shairport = {
          enable = true;
          port = 5001;
        };
      };

      programs = {
        bash.hostcolor = "\\033[38;5;160m";
        sway.brightnessDevice = "intel_backlight";
      };

      opts = {
        screens = {
          "BOE 0x06B3" = {
            sway.position = "0 0";
          };
          "Acer Technologies XV271U M3 140400E433LIJ" = {
            sway.position = "1366 -672";
            specialisations = {
              "work monitor left".sway = {
                position = "-2560 -672";
              };
              "work monitor above".sway = {
                position = "-597 -1440";
              };
            };
          };
          "LG Electronics LG TV 0x01010101" = {
            sway.position = "0 -1080";
          };
          "Hewlett Packard HP 22cwa 6CM6120J0Z" = {
            sway.position = "-1920 0";
          };
        };
        wallpaper = ../../../../../secrets/git-crypt/wallpaper/r9yiw8xx.png;
        colorscheme = import ./colorscheme.nix;
      };
    };

    age = {
      secretsDir = "/run/user/1001/agenix";
      identityPaths = [ "${config.home.homeDirectory}/.ssh/id_ed25519" ];
    };
  };
}
