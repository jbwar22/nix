{ config, lib, pkgs, ... }:

with lib; mkNsEnableModule config ./. {
  environment.systemPackages = with pkgs; [
    vim
  ];
}
