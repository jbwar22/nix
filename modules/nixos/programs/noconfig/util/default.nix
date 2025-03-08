{ config, lib, pkgs, ... }:

with lib; with namespace config { nixos.programs.noconfig.util = ns; }; {
  options = opt {
    enable = mkEnableOption "util programs";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      git-crypt   # needed for using this repo
    ];
  };
}
