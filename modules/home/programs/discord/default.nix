{ config, lib, pkgs, ... }:

with lib; mkNsEnableModule config ./. (let
  # github:sersorrel/sys
  krisp-patcher-python = pkgs.writers.writePython3Bin "krisp-patcher-python" {
    libraries = with pkgs.python3Packages; [ capstone pyelftools ];
    flakeIgnore = [
      "E501" # line too long (82 > 79 characters)
      "F403" # ‘from module import *’ used; unable to detect undefined names
      "F405" # name may be undefined, or defined from star imports: module
    ];
  } (builtins.readFile ./krisp-patcher.py);
  krisp-patcher = pkgs.writeShellScriptBin "krisp-patcher" ''
    ${pkgs.procps}/bin/pkill -9 Discord
    ${krisp-patcher-python}/bin/krisp-patcher-python ~/.config/discord/0.*/modules/discord_krisp/discord_krisp.node
  '';
in {
  home.packages = with pkgs; [ 
    (wrapAndAddFlags discord [
      "--use-gl=egl" # this appears to be the one that fixes flickering
      "--wayland-text-input-version=3"
      "--enable-features=VaapiVideoDecoder,VaapiVideoEncoder"
      "--ignore-gpu-blocklist"
      "--enable-gpu-rasterization"
      "--enable-zero-copy"
      "--disable-software-rasterizer"
      "--enable-accelerated-video-decode"
      "--enable-accelerated-mjpeg-decode"
      "--use-vulkan"
    ])
    krisp-patcher
  ];

  custom.home.behavior.impermanence.paths = [ ".config/discord" ];
})
