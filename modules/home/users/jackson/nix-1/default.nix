{ pkgs, ... }:

{
  home.packages = with pkgs; [
    cowsay
  ];

  home.stateVersion = "24.11";
}
