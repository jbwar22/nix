{ pkgs, ns, ... }:

ns.enable {
  environment.systemPackages = with pkgs; [
    openvpn
    networkmanager-openvpn
    wireguard-tools
  ];
}
