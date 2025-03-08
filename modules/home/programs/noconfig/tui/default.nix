{ config, lib, pkgs, inputs, ... }:

with lib; with namespace config { home.programs.noconfig.tui = ns; }; {
  options = opt {
    enable = mkEnableOption "tui programs with no additional config";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      htop
      pulsemixer
      vim
      nixvim-custom
      inputs.home-manager.packages.${pkgs.system}.default
      inputs.agenix.packages.${pkgs.system}.default
    ];
  };
}
