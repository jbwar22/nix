{ config, lib, ... }:

with lib; mkNsEnableModule config ./. {
  programs.tmux = {
    enable = true;
    clock24 = true;
    mouse = true;
    prefix = "C-a";
    baseIndex = 1;
  };
}
