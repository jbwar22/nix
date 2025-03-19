{ config, lib, ... }:

with lib; mkNsEnableModule config ./. {
  custom.home = {
    programs = {
      fcitx5.enable = true;
    };
  };
}
