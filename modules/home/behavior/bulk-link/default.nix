{ config, lib, pkgs, ... }:

with lib; mkNsEnableModule config ./. {
  home.file."bulk".source = config.lib.file.mkOutOfStoreSymlink "/bulk/${config.home.username}";
}
