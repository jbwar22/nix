{ inputs, config, lib, pkgs, ... }:

with lib; mkNsEnableModule config ./. {
  programs.quickshell = {
    enable = true;
    systemd.enable = true;
    configs = {
      default = ./config;
      # live-update config is meant for rapid testing, not actual usage
      live-update = config.lib.file.mkOutOfStoreSymlink (getConfigPath config ./config);
    };
  };

  systemd.user.services.quickshell.Service.Environment = [
    "PATH=${
      makeBinPath (with pkgs; [
        inputs.clonck.packages.${pkgs.stdenv.hostPlatform.system}.clonck
        acpi
        bash
        coreutils
        jq
        procps
        sway
        sysstat
      ])
    }"
  ];
}
