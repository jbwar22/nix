{ config, lib, pkgs, ... }:

with lib; mkNsEnableModule config ./. (let
  # github:sersorrel/sys
  krisp-patcher = pkgs.writers.writePython3Bin "krisp-patcher" {
    libraries = with pkgs.python3Packages; [ capstone pyelftools ];
    flakeIgnore = [
      "E501" # line too long (82 > 79 characters)
      "F403" # ‘from module import *’ used; unable to detect undefined names
      "F405" # name may be undefined, or defined from star imports: module
    ];
  } (builtins.readFile ./krisp-patcher.py);
in {
  home.packages = with pkgs; [ 
    discord
    krisp-patcher
  ];

  home.persistence = persistUserDirs config [ ".config/discord" ];
})
