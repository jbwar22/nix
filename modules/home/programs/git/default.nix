{ config, lib, pkgs, ns, ... }:

with lib; ns.enable {
  home.packages = with pkgs; [
    git
    git-crypt
  ];

  custom.home.behavior.impermanence.paths = [
    { path = ".gitconfig"; file = true; }
  ];
}
