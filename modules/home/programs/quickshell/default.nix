{ inputs, config, lib, pkgs, ... }:

with lib; mkNsEnableModule config ./. {
  home.packages = with pkgs; [
    quickshell
  ];

  programs.quickshell = {
    enable = true;
    configs = {
      default = ./config;
      # live-update config is meant for rapid testing, not actual usage
      live-update = config.lib.file.mkOutOfStoreSymlink (getConfigPath config ./config);
    };
  };

  xdg.configFile."quickshell/binaries.mjs".text = let
    clonck = inputs.clonck.packages.${pkgs.stdenv.hostPlatform.system}.clonck;
    binaries = pipe [
      [ "clonck" "${clonck}/bin/clonck" ]
      [ "mpstat" "${pkgs.sysstat}/bin/mpstat" ]
      [ "acpi" "${pkgs.acpi}/bin/acpi" ]
    ] [
      (map (x: "\"${head x}\": \"${last x}\","))
      (concatStringsSep "\n")
    ];
  in ''
    export function getBinaries() {
      return {
        ${binaries}
      }
    }
  '';
}
