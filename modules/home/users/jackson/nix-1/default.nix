{ pkgs, ... }:

{
  home.packages = [
    pkgs.cowsay
  ];

  home.stateVersion = "24.11";
}
