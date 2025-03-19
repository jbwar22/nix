{ config, lib, ... }:

with lib; mkNsEnableModule config ./. {
  specialisation.nvidia-fallback.configuration = {
    environment.etc.specialisation.text = "nvidia-fallback";
    hardware.nvidia.package = mkForce config.boot.kernelPackages.nvidiaPackages.beta;
  };

  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    # TODO grab from unstable channel directly?
    # https://github.com/NixOS/nixpkgs/blob/master/pkgs/os-specific/linux/nvidia-x11/default.nix
    package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      version = "570.86.16";
      sha256_64bit = "sha256-RWPqS7ZUJH9JEAWlfHLGdqrNlavhaR1xMyzs8lJhy9U=";
      sha256_aarch64 = "sha256-RiO2njJ+z0DYBo/1DKa9GmAjFgZFfQ1/1Ga+vXG87vA=";
      openSha256 = "sha256-DuVNA63+pJ8IB7Tw2gM4HbwlOh1bcDg2AN2mbEU9VPE=";
      settingsSha256 = "sha256-9rtqh64TyhDF5fFAYiWl3oDHzKJqyOW3abpcf2iNRT8=";
      persistencedSha256 = "sha256-3mp9X/oV8o2TH9720NnoXROxQ4g98nNee+DucXpQy3w=";
    };
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
