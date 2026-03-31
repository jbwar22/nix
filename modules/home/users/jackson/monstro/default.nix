{ config, clib, ... }:

{
  config = {
    home.stateVersion = "24.05";

    custom.home = {
      suites = {
        pc.enable = true;
      };

      behavior = {
        xdg.defaultBrowser = "firefox.desktop";
        impermanence = {
          enable = true;
        };
        bulk-link.enable = true;
        default-audio = {
          default-routes = ''
            alsa_card.pci-0000_09_00.4:output:analog-output-lineout={"channelMap":["FL", "FR"], "mute":false, "latencyOffsetNsec":0, "channelVolumes":[0.125000, 0.125000]}
          '';
          default-nodes = ''
            default.configured.audio.sink=alsa_output.pci-0000_09_00.4.analog-stereo
            default.configured.audio.sink.0=alsa_output.usb-Universal_Audio_Volt_176_21502038005257-00.analog-stereo
          '';
        };
      };

      programs = {
        sway.blueLightFilter = true;
        sway.blueLightStrength = 5000;
        firefox.usePackage = true;
        virt-manager.enable = true;
        bash.hostcolor = "\\033[38;5;140m";
        bash.sourcedFiles = [ "/home/jackson/documents/scripts/monstrorc" ];
        mavica-ingest.enable = true;
        easyeffects.enable = true;
        osu.enable = true;
      };

      services = {
        shairport = {
          enable = true;
          port = 5001;
        };

        rclone = {
          enable = true;
          logDir = "~/documents/log/rclone";
          timeFile = "~/bulk/data/rclone/timefile.txt";
          configs = with clib; {
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

      opts = let
        wallpaper = "/home/${config.home.username}/pictures/wallpapers/wallpaper";
        wallpaper_bg2 = "/home/${config.home.username}/pictures/wallpapers/wallpaper_bg2";
      in {
        screens = {
          "ASUSTek COMPUTER INC VG278 J8LMQS104073" = {
            sway = {
              position = "0 0";
              adaptive_sync = "off";
              bg = "${wallpaper} fill #000000";
            };
            specialisations = {
              bg2.sway.bg = "${wallpaper_bg2} fill #000000";
            };
          };
          "ASUSTek COMPUTER INC VG27AQL1A S1LMQS102258" = {
            sway = {
              position = "1920 0";
              adaptive_sync = "off";
              transform = "0";
              bg = "${wallpaper} fill #000000";
            };
            specialisations = {
              vert.sway = {
                transform = "90";
                position = "1920 -740";
              };
              bg2.sway.bg = "${wallpaper_bg2} fill #000000";
            };
          };
          "BNQ BenQ GW2780 V1J07047SL0" = {
            sway = {
              position = "4480 0";
              bg = "${wallpaper} fill #000000";
            };
            specialisations = {
              vert.sway = {
                position = "3360 0";
              };
              bg2.sway.bg = "${wallpaper_bg2} fill #000000";
            };
          };
        };
        wallpaper.base = wallpaper;
        colorscheme = import ./colorscheme.nix;
      };
    };

    age = {
      secretsDir = "/run/user/1000/agenix";
      identityPaths = [ "${config.home.homeDirectory}/.ssh/id_rsa" ];
    };
  };
}
