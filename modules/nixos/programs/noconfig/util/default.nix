{ config, lib, pkgs, ... }:

with lib; with ns config ./.; {
  options = opt {
    enable = mkEnableOption "util programs";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      git-crypt   # needed for using this repo
    ];
  };
}
