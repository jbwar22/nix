{ config, lib, ... }:

with lib; mkNsEnableModule config ./. {
  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
  };

  home.persistence = persistUserDirs config [ ".local/share/direnv" ];
}
