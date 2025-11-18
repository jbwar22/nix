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
      package = mkIf cfg.useUnstableMesa pkgs.unstable.mesa;
    };

    hardware.amdgpu.amdvlk = mkIf (config.custom.common.opts.hardware.gpu == enums.gpu-vendors.amd) {
        enable = true;
        support32Bit.enable = true;
    };

    environment.systemPackages = with pkgs; [
      dconf  # gtk
    ];
  };
}
