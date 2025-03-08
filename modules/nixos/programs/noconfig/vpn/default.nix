{ config, lib, pkgs, ... }:

with lib; with namespace config { nixos.programs.noconfig.vpn = ns; }; {
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
