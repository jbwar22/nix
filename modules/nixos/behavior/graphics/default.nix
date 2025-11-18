{ config, lib, pkgs, ... }:

with lib; mkNsEnableModule config ./. {
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.amdgpu.amdvlk = mkIf (config.custom.common.opts.hardware.gpu == enums.gpu-vendors.amd) {
      enable = true;
      support32Bit.enable = true;
  };

  environment.systemPackages = with pkgs; [
    dconf  # gtk
    vulkan-tools
  ];
}
