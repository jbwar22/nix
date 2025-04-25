{ config, lib, pkgs, ... }:

with lib; mkNsEnableModule config ./. {
  specialisation.lts.configuration = let
    kernelPackages = pkgs.linuxPackages_6_12;
  in {
    environment.etc.specialisation.text = "6.12, NVIDIA latest 565";
    boot.kernelPackages = mkForce kernelPackages;
    hardware.nvidia.package = mkForce kernelPackages.nvidiaPackages.latest;
  };

  services.xserver.videoDrivers = ["nvidia"];

  boot.kernelPackages = mkDefault pkgs.linuxPackages_latest_unstable;

  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.beta;
    open = false;

    modesetting.enable = true;
    powerManagement.enable = false;

    nvidiaSettings = true;
  };

  # initrd.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_udm" "nvidia_drm" ];

  boot = {
    kernelParams = [
      "nvidia-drm.fbdev=1"
    ];
    extraModprobeConfig = "options nvidia-drm";
    blacklistedKernelModules = [ "nouveau" ];
  };
}
