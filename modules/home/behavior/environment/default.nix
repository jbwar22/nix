{ config, lib, ... }:

with lib; mkNsEnableModule config ./. {
  home.sessionVariables = {
    EDITOR = "vim";
  };
}
