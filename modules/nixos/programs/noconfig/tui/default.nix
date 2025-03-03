{ config, lib, pkgs, ... }:

with lib;
let
  inherit (namespace config { nixos.programs.noconfig.tui = ns; }) cfg opt;
in
{
  options = opt {
    enable = mkEnableOption "basic tui programs available in root shell";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      vim
    ];
  };
}
