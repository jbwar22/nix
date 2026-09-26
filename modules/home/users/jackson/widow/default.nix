{ config, ... }:

{
  config = {
    home.stateVersion = "23.11";

    custom.home = {
      suites = {
        pc.enable = true;
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
        waybar.enable = true;
        mpv.compat = true;
      };

      opts = {
        screens = {
          "BOE 0x06B3" = {
            sway.position = "0 0";
          };
          "LG Electronics LG TV 0x01010101" = {
            sway.position = "0 -1080";
          };
          "Hewlett Packard HP 22cwa 6CM6120J0Z" = {
            sway.position = "-1920 0";
          };
          "VIZIO, Inc E601i-A3 UKJWAM0100001" = {
            sway.position = "0 -1080";
          };
        };
        wallpaper.dir = "/home/${config.home.username}/pictures/wallpapers/active";
        colorscheme = import ./colorscheme.nix;
      };
    };

    age = {
      secretsDir = "/run/user/1001/agenix";
      identityPaths = [ "${config.home.homeDirectory}/.ssh/id_ed25519" ];
    };
  };
}
