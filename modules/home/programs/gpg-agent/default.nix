{ config, lib, ... }:

with lib; mkNsEnableModule config ./. {
  services.gpg-agent = {
    enable = true;
  };
}
