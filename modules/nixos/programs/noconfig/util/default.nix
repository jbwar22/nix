{ config, lib, pkgs, ... }:

with lib;
let
  inherit (namespace config { nixos.programs.noconfig.util = ns; }) cfg opt;
in
{
  options = opt {
    enable = mkEnableOption "util programs";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      git-crypt   # needed for using this repo
    ];
  };
}
