{ pkgs, ns, ... }:

ns.enable {
  environment.systemPackages = [
    pkgs.openvpn
    pkgs.networkmanager-openvpn
    pkgs.wireguard-tools
    pkgs.wireproxy
  ];
}
