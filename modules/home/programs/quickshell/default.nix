{ inputs, config, lib, clib, pkgs, ns, ... }:

with lib; ns.enable {
  programs.quickshell = {
    enable = true;
    systemd.enable = true;
    configs = {
      default = ./config;
      # live-update config is meant for rapid testing, not actual usage
      live-update = config.lib.file.mkOutOfStoreSymlink (clib.getConfigPath config ./config);
    };
  };

  systemd.user.services.quickshell.Service.Environment = [
    "PATH=${
      makeBinPath (with pkgs; [
        inputs.clonck.packages.${pkgs.stdenv.hostPlatform.system}.clonck
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
