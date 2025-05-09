{ config, lib, ... }:

with lib; {
  config = {
    home.stateVersion = "24.11";

    custom.home = {
      services.locker.enable = mkForce false;

      suites = {
        pc.enable = true;
        work.enable = true;
      };

      behavior = {
        impermanence = {
          enable = true;
          persistPath = "/persist/home/jackson";
        };
        default-audio = {
          enable = true;
          default-routes = ''
            [default-routes]
            alsa_card.pci-0000_c1_00.6:output:analog-output-speaker={"channelMap":["FL", "FR"], "channelVolumes":[0.125000, 0.125000], "latencyOffsetNsec":0, "mute":true}
          '';
        };
      };

      programs = {
        bash.hostcolor = "\\033[38;5;111m";
      };

      opts = {
        screens = {
          "BOE NE135A1M-NY1" = {
            sway = {
              resolution = "2880x1920@120.000Hz";
              position = "0 0";
              bg = "${../../../../../secrets/git-crypt/wallpaper/r9yiw8xx.png} fill";
            };
            bar = "bar1920_2x";
            noserial = true;
            clamshell = true;
          };
          "Acer Technologies XV271U M3 140400E433LIJ" = {
            sway = {
              resolution = "2560x1440@180.002Hz";
              position = "1440 -650";
              bg = "${../../../../../secrets/git-crypt/wallpaper/r9yiw8xx.png} fill";
            };
            bar = "bar1440";
            specialisations = {
              "work monitor above".sway = {
                position = "-560 -1440";
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
      # secretsDir = "/run/user/1000/agenix";
      # identityPaths = [ "${config.home.homeDirectory}/.ssh/id_ed25519" ];
    };
  };
}
