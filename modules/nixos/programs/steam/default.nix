{ config, lib, pkgs, ... }:

with lib; with namespace config { nixos.programs.steam = ns; }; {
  options = opt {
    enable = mkEnableOption "steam";
  };

  config = lib.mkIf cfg.enable {

    hardware.steam-hardware.enable = true;

    programs.steam = {
      enable = true;
      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
      extraPackages = with pkgs; [
        gamescope
        mangohud
        gamemode
      ];
      extest.enable = true; # steam input on wayland
      localNetworkGameTransfers.openFirewall = true;
    };

  };
}
