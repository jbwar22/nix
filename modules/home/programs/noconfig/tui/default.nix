{ config, lib, pkgs, inputs, ... }:

with lib;
let
  inherit (namespace config { home.programs.noconfig.tui = ns; }) cfg opt;
in
{
  options = opt {
    enable = mkEnableOption "tui programs with no additional config";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      htop
      pulsemixer
      vim
      nixvim-custom
      inputs.home-manager.packages."x86_64-linux".default
    ];
  };
}
