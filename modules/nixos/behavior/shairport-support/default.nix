{ lib, ns, ... }:

let
  inherit (ns)
  cfg
  ecfg
  eopt;
  inherit (lib)
  allUnique
  mkDefault
  mkOption
  throwIfNot;
  inherit (lib.types)
  listOf
  number;
in {
  options = eopt {
    ports = mkOption {
      description = "ports to open for shairport-sync";
      type = listOf number;
      default = [ 5000 ];
    };
  };
  config = ecfg {
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
      allowedTCPPorts = throwIfNot (allUnique cfg.ports) "shairport-support: duplicate shairport ports set" cfg.ports;
      allowedUDPPortRanges = [ { from = 6001; to = 6011; } ];
    };
  };
}
