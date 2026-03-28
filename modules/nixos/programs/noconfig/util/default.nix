{ config, lib, pkgs, ns, ... }:

with lib; ns.enable {
  environment.systemPackages = with pkgs; [
    git-crypt   # needed for using this repo
  ];
}
