{ config, lib, ... }:

with lib; with ns config ./.; {
  options = opt {
    enable = mkEnableOption "extra required options for easy use of shairport-sync";
  };
  config = lib.mkIf cfg.enable {
    # taken from:
    # https://github.com/NixOS/nixpkgs/blob/nixos-24.11/nixos/modules/services/networking/shairport-sync.nix
    # needed separate because I want to run shairport-sync itself via home-manager as a user service

    services.avahi = {
      enable = mkDefault true;
      publish = {
        enable = mkDefault true;
        userServices = mkDefault true;
      };
    };
    
    networking.firewall = {
      allowedTCPPorts = [ 5000 ];
      allowedUDPPortRanges = [ { from = 6001; to = 6011; } ];
    };
  };
}
