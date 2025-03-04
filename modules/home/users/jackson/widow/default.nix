{ config, lib, ... }:

with lib; {
  config = {
    home.stateVersion = "23.11";
    home.homeDirectory = "/home/jackson";

    custom.home = {
      suites = {
        work.enable = true;
      };

      opts = {
        screens.definition = [
          { name = "BOE 0x06B3";
            noserial = true;
            bar = "bar768";
            resolution = "1366x768@60.058Hz";
            position = "0 0";
            wallpaper.file = "r9yiw8xx.png";
          }
          { name = "Acer Technologies XV271U M3 140400E433LIJ";
            bar = "bar1440";
            resolution = "2560x1440@165.002Hz";
            position = "1366 -672";
            wallpaper.file = "r9yiw8xx.png";
          }
          { name = "LG Electronics LG TV 0x01010101";
            bar = "bar1080";
            resolution = "1920x1080@60.000hz";
            position = "0 -1080";
            wallpaper.file = "r9yiw8xx.png";
          }
        ];
        wallpaper.file = "r9yiw8xx.png";

        colorscheme = import ./colorscheme.nix;
      };
    };
    age = {
      secretsDir = "/run/user/1001/agenix";
      identityPaths = [ "${config.home.homeDirectory}/.ssh/id_ed25519" ];
      secrets = {
        geolocation.file = ../../../../../secrets/agenix/users/jackson/widow/geolocation.age;
      };
    };
  };
}
