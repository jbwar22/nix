{ config, lib, pkgs, ... }:

with lib; with namespace config { nixos.programs.noconfig.tui = ns; }; {
  options = opt {
    enable = mkEnableOption "basic tui programs available in root shell";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      vim
    ];
  };
}
