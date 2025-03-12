{ config, lib, pkgs, ... }:

with lib; with ns config ./.; {
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
