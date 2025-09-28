{ config, lib, ... }:

with lib; {
  config = {
    home.stateVersion = "24.05";

    custom.home = {
      suites = {
        pc.enable = true;
      };

      behavior = {
        xdg.defaultBrowser = "firefox.desktop";
      };

      programs = {
        sway.blueLightFilter = true;
        sway.blueLightStrength = 5000;
        firefox.usePackage = true;
        virt-manager.enable = true;
        bash.hostcolor = "\\033[38;5;140m";
      };

      services = {
        shairport = {
          enable = true;
          port = 5001;
        };

        rclone = {
          enable = true;
          logDir = "~/documents/log/rclone";
          configs = {
            dh5exd2a = {
              # oncalendar = "*-*-* 05:00:00";
              rcloneargs = ageOrNull config "rclone-dh5exd2a-args";
              rcloneconf = ageOrNull config "rclone-the-forsaken-conf";
            };
            ay5efs34 = {
              # oncalendar = "*-*-* 05:01:00";
              rcloneargs = ageOrNull config "rclone-ay5efs34-args";
              rcloneconf = ageOrNull config "rclone-the-forsaken-conf";
            };
          };
        };
      };

      opts = {
        screens = {
          "ASUSTek COMPUTER INC VG278 J8LMQS104073" = {
            sway = {
              position = "0 0";
              adaptive_sync = "off";
              bg = "${../../../../../secrets/git-crypt/wallpaper/iyxxfe0y.png} fill";
            };
            specialisations = {
              bg2.sway.bg = "${../../../../../secrets/git-crypt/wallpaper/p2up0wv6.png} fill";
            };
          };
          "ASUSTek COMPUTER INC VG27AQL1A S1LMQS102258" = {
            sway = {
              position = "1920 0";
              adaptive_sync = "off";
              transform = "0";
              bg = "${../../../../../secrets/git-crypt/wallpaper/iyxxfe0y.png} fill";
            };
            specialisations = {
              vert.sway = {
                transform = "90";
                position = "1920 -740";
              };
              bg2.sway.bg = "${../../../../../secrets/git-crypt/wallpaper/p2up0wv6.png} fill";
            };
          };
          "BNQ BenQ GW2780 V1J07047SL0" = {
            sway = {
              position = "4480 0";
              bg = "${../../../../../secrets/git-crypt/wallpaper/iyxxfe0y.png} fill";
            };
            specialisations = {
              vert.sway = {
                position = "3360 0";
              };
              bg2.sway.bg = "${../../../../../secrets/git-crypt/wallpaper/p2up0wv6.png} fill";
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
