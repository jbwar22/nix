{ config, lib, ... }:

with lib; mkNsEnableModule config ./. {
  programs.fastfetch = {
    enable = true;
    settings = {
      modules = [
        "title"

        "separator"

        "os"
        "kernel"

        "separator"

        "host"
        "cpu"
        "gpu"
        "memory"
        "physicalmemory"
        "display"
        "battery"
        "disk"

        "separator"

        "wm"
        "cursor"
        "terminal"
        "shell"

        "separator"

        "uptime"
        "packages"

        "break"

        "colors"
      ];
    };
  };
}
