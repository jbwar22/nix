{ config, lib, pkgs, ... }:

with lib; mkNsEnableModule config ./. {
  programs.atuin = {
    enable = true;
    daemon.enable = true;
    enableBashIntegration = true;
    flags = [
      "--disable-up-arrow"
    ];
    settings = {
      enter_accept = true;
      style = "compact";
      invert = true;
      inline_height = 10;
    };
  };

  custom.home.behavior.impermanence.paths = [ ".local/share/atuin" ];
}
