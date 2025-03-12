{ config, lib, pkgs, ... }:

with lib; with ns config ./.; {
  options = opt {
    enable = mkEnableOption "fastfetch";
  };

  config = mkIf cfg.enable {
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
  };
}
