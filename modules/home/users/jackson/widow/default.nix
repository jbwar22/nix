{ config, lib, ... }:

with lib; {
  config = {
    home.stateVersion = "23.11";

    custom.home = {
      suites = {
        work.enable = true;
      };

      opts = {
        screens = {
          "BOE 0x06B3" = {
            sway = {
              resolution = "1366x768@60.058Hz";
              position = "0 0";
              bg = "${../../../../../secrets/git-crypt/wallpaper/r9yiw8xx.png} fill";
            };
            bar = "bar768";
            noserial = true;
          };
          "Acer Technologies XV271U M3 140400E433LIJ" = {
            sway = {
              resolution = "2560x1440@165.002Hz";
              position = "1366 -672";
              bg = "${../../../../../secrets/git-crypt/wallpaper/r9yiw8xx.png} fill";
            };
            bar = "bar1440";
            specialisations = {
              "work monitor left".sway = {
                position = "-2560 -672";
              };
            };
          };
          "LG Electronics LG TV 0x01010101" = {
            sway = {
              resolution = "1920x1080@60.000hz";
              position = "0 -1080";
              bg = "${../../../../../secrets/git-crypt/wallpaper/r9yiw8xx.png} fill";
            };
            bar = "bar1080";
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
