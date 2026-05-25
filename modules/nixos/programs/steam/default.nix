{ pkgs, ns, ... }:

ns.enable {
  hardware.steam-hardware.enable = true;

  programs.steam = {
    enable = true;
    package = pkgs.steam.override {
      extraLibraries = pkgs: with pkgs; [
        hidapi
      ];
    };
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
    extraPackages = with pkgs; let
      # fix gamescope lag bomb
      # alternative one-liner:
      # env -u LD_PRELOAD gamescope -h 1440 -H 1440 -f -- env LD_PRELOAD="$LD_PRELOAD" %command%
      ld_gamescope = (writeShellScriptBin "ld_gamescope" ''
        env -u LD_PRELOAD LD_BIND_NOW=1 exec ${pkgs.gamescope}/bin/gamescope -f -w 2560 -W 2560 -h 1440 -H 1440 --force-grab-cursor -- env LD_PRELOAD="$LD_PRELOAD" "$@"
      '');
    in [
      gamescope
      mangohud
      gamemode
      ld_gamescope
    ];
    extest.enable = true; # steam input on wayland
    localNetworkGameTransfers.openFirewall = true;
    protontricks.enable = true;
  };
}
