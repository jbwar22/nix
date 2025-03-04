{ lib, ... }:

with lib; {
  config = {
    home.stateVersion = "24.05";
    home.homeDirectory = "/home/jackson";

    custom.home = {
      programs = {
        sway.blueLightFilter = true;
        sway.blueLightStrength = 5000;
        fcitx5.basic = true;
        firefox.usePackage = true;
      };

      opts = {
        secrets = {
          geoLoc = trim (readFile ../../../../../secrets/git-crypt/strings/geoloc-monstro.txt);
        };
        screens.definition = [
          { name = "ASUSTek COMPUTER INC VG278 J8LMQS104073";
            bar = "bar1080";
            resolution = "1920x1080@144.001Hz";
            position = "0 0";
            wallpaper.file = "p2up0wv6.png";
          }
          { name = "ASUSTek COMPUTER INC VG27AQL1A S1LMQS102258";
            bar = "bar1440";
            resolution = "2560x1440@170.004Hz";
            position = "1920 0";
            wallpaper.file = "p2up0wv6.png";
          }
          { name = "BNQ BenQ GW2780 V1J07047SL0";
            bar = "bar1080";
            resolution = "1920x1080@60.000Hz";
            position = "4480 0";
            wallpaper.file = "p2up0wv6.png";
          }
        ];
        wallpaper.file = "iyxxfe0y.png";

        colorscheme = import ./colorscheme.nix;
      };
    };
  };
}
