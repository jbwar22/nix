{ config, lib, ... }:

with lib; mkNsEnableModule config ./. {
  services.gpg-agent = {
    enable = true;
  };

  custom.home.behavior.impermanence.dirs = [ ".gnupg" ];
}
