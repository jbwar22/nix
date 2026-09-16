{ inputs, lib, pkgs, ns, ... }:

ns.enable {
  programs.quickshell = {
    enable = true;
    systemd.enable = true;
    configs = {
      default = inputs.shell;
    };
  };

  systemd.user.services.quickshell.Service.Environment = [
    "PATH=${
      lib.makeBinPath ([
        inputs.clonck.packages.${pkgs.stdenv.hostPlatform.system}.clonck
        pkgs.bash
        pkgs.coreutils
        pkgs.jq
        pkgs.procps
        pkgs.sway
        pkgs.sysstat
      ])
    }"
  ];
}
