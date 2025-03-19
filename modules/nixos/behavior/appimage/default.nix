{ config, lib, ... }:

with lib; mkNsEnableModule config ./. {
  programs.appimage.binfmt = true;
}
