{ config, lib, ... }:

with lib; mkNsEnableModule config ./. {
  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
  };
}
