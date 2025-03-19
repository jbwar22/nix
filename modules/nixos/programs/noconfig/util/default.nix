{ config, lib, pkgs, ... }:

with lib; mkNsEnableModule config ./. {
  environment.systemPackages = with pkgs; [
    git-crypt   # needed for using this repo
  ];
}
