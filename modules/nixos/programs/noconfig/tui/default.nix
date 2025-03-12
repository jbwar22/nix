{ config, lib, pkgs, ... }:

with lib; with ns config ./.; {
  options = opt {
    enable = mkEnableOption "basic tui programs available in root shell";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      vim
    ];
  };
}
