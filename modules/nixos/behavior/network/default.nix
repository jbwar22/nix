{ config, lib, ... }:

with lib;
let
  inherit (namespace config { nixos.behavior.network = ns; }) cfg opt;
in
{
  options = opt {
    enable = mkEnableOption "networking";
  };

  config = lib.mkIf cfg.enable {
    networking.networkmanager.enable = true;

    # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
    # (the default) this is the recommended approach. When using systemd-networkd it's
    # still possible to use this option, but it's recommended to use it in conjunction
    # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
    networking.useDHCP = lib.mkDefault true;
    # networking.interfaces.enp0s31f6.useDHCP = lib.mkDefault true;
    # networking.interfaces.wlp3s0.useDHCP = lib.mkDefault true;
  };
}
