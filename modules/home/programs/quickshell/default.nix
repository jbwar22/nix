{ inputs, config, lib, clib, pkgs, ns, ... }:

with lib; ns.enable {
  programs.quickshell = {
    enable = true;
    systemd.enable = true;
    configs = {
      default = inputs.shell;
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
