{ config, lib, pkgs, ... }:

with lib;
let
  inherit (namespace config { nixos.programs.noconfig.vpn = ns; }) cfg opt;
in
{
  options = opt {
    enable = mkEnableOption "required packages for vpn usage";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      openvpn
      networkmanager-openvpn
      wireguard-tools
    ];
  };
}
