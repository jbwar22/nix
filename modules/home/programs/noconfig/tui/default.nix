{ config, lib, pkgs, inputs, outputs, ... }:

with lib; with ns config ./.; {
  options = opt {
    enable = mkEnableOption "tui programs with no additional config";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      htop
      pulsemixer
      vim
      outputs.packages.${pkgs.system}.nixvim
      inputs.home-manager.packages.${pkgs.system}.default
      inputs.agenix.packages.${pkgs.system}.default
    ];
  };
}
