{ config, lib, pkgs, ... }:

with lib; with ns config ./.; {
  options = opt {
    enable = mkEnableOption "graphics";
    useUnstableMesa = mkEnableOption "use unstable mesa drivers";
  };

  config = mkIf cfg.enable {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      package = mkIf cfg.useUnstableMesa pkgs.mesa_unstable;
    };

    environment.systemPackages = with pkgs; [
      dconf  # gtk
    ];
  };
}
