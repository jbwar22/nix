{ lib, pkgs, ns, ... }:

with lib; ns.enable {
  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        type = "file";
        source = pipe {
          url = "https://raw.githubusercontent.com/4DBug/nix-ansi/bea824b1f863a4b0ee5e8c8f5c5e92e8207b3705/nix.txt";
          hash = "sha256-K1qBJHAl+sTeeB1WrNbOWf2a/6QAWAXXPiSC2XFHI2E=";
        } [
          pkgs.fetchurl
          readFile
          (splitString "\n")
          (map (x: "  ${x}"))
          concatLines
          (x: "\n${x}")
          (pkgs.writeText "fastfetch-nix-logo")
        ];
      };
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
        # "disk"

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
