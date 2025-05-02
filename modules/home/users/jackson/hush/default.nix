{ config, lib, ... }:

with lib; {
  config = {
    home.stateVersion = "24.11";

    custom.home = {
      suites = {
        pc.enable = true;
        work.enable = true;
      };

      opts = {
        screens = {};
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
