{ config, lib, ... }:

with lib; {
  config = {
    home.stateVersion = "24.11";

    custom.home = {
      services = {
        locker.enable = mkForce false;
        shairport.enable = true;
      };

      suites = {
        pc.enable = true;
        work.enable = true;
      };

      behavior = {
        impermanence = {
          enable = true;
        };
        bulk-link.enable = true;
        default-audio.default-routes = ''
          alsa_card.pci-0000_c1_00.6:output:analog-output-speaker={"channelMap":["FL", "FR"], "channelVolumes":[0.125000, 0.125000], "latencyOffsetNsec":0, "mute":true}
          alsa_card.pci-0000_c1_00.6:input:analog-input-internal-mic={"channelVolumes":[0.015625, 0.015625], "mute":false, "latencyOffsetNsec":0, "channelMap":["FL", "FR"]}
        '';
      };

      programs = {
        bash.hostcolor = "\\033[38;5;111m";
        sway.brightnessDevice = "amdgpu_bl1";
        # xscreensaver.enable = true;
        mavica-ingest.enable = true;
        virt-manager.enable = true;
        quickshell.enable = true;

        easyeffects = {
          enable = true;
          preset = "gracefu";
        };
      };

      opts = {
        screens = {
          "BOE NE135A1M-NY1" = {
            sway.position = "2560 650";
            clamshell = true;
          };
          "Acer Technologies XV271U M3 140400E433LIJ" = {
            sway.position = "0 0";
            specialisations = {
              "work monitor right".sway = {
                position = "1440 -650";
              };
              "work monitor above".sway = {
                position = "-560 -1440";
              };
            };
          };
          "LG Electronics LG TV 0x01010101" = {
            sway.position = "0 -1080";
          };
        };
        wallpaper.dir = "/home/${config.home.username}/pictures/wallpapers/active";
        colorscheme = import ./colorscheme.nix;
      };
    };

    age = {
      secretsDir = "/run/user/1000/agenix";
      # identityPaths = [ "${config.home.homeDirectory}/.ssh/id_ed25519" ];
    };
  };
}
