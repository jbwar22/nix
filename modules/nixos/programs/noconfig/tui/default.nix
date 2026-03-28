{ config, lib, pkgs, ns, ... }:

with lib; ns.enable {
  environment.systemPackages = with pkgs; [
    vim
  ];
}
