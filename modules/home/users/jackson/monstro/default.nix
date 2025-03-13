{ config, lib, ... }:

with lib; {
  config = {
    home.stateVersion = "24.05";

    custom.home = {
      programs = {
        sway.blueLightFilter = true;
        sway.blueLightStrength = 5000;
        firefox.usePackage = true;
      };

      opts = {
        screens = {
          "ASUSTek COMPUTER INC VG278 J8LMQS104073" = {
            sway = {
              resolution = "1920x1080@144.001Hz";
              position = "0 0";
              adaptive_sync = "off";
              bg = "${../../../../../secrets/git-crypt/wallpaper/p2up0wv6.png} fill";
            };
            bar = "bar1080";
          };
          "ASUSTek COMPUTER INC VG27AQL1A S1LMQS102258" = {
            sway = {
              resolution = "2560x1440@170.004Hz";
              position = "1920 0";
              adaptive_sync = "off";
              transform = "0";
              bg = "${../../../../../secrets/git-crypt/wallpaper/p2up0wv6.png} fill";
            };
            bar = "bar1440";
            specialisations = {
              vert.sway = {
                transform = "90";
                position = "1920 -740";
              };
            };
          };
          "BNQ BenQ GW2780 V1J07047SL0" = {
            sway = {
              resolution = "1920x1080@60.000Hz";
              position = "4480 0";
              bg = "${../../../../../secrets/git-crypt/wallpaper/p2up0wv6.png} fill";
            };
            bar = "bar1080";
            specialisations = {
              vert.sway = {
                position = "3360 0";
              };
            };
          };
        };
        wallpaper = ../../../../../secrets/git-crypt/wallpaper/iyxxfe0y.png;
        colorscheme = import ./colorscheme.nix;
      };
    };

    age = {
      secretsDir = "/run/user/1000/agenix";
      identityPaths = [ "${config.home.homeDirectory}/.ssh/id_rsa" ];
    };
  };
}
