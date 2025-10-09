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

  hardware.nvidia = {
    # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/os-specific/linux/nvidia-x11/generic.nix
    package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      version = "580.95.05";
      sha256_64bit = "sha256-hJ7w746EK5gGss3p8RwTA9VPGpp2lGfk5dlhsv4Rgqc=";
      sha256_aarch64 = "sha256-zLRCbpiik2fGDa+d80wqV3ZV1U1b4lRjzNQJsLLlICk=";
      openSha256 = "sha256-RFwDGQOi9jVngVONCOB5m/IYKZIeGEle7h0+0yGnBEI=";
      settingsSha256 = "sha256-F2wmUEaRrpR1Vz0TQSwVK4Fv13f3J9NJLtBe4UP2f14=";
      persistencedSha256 = "sha256-QCwxXQfG/Pa7jSTBB0xD3lsIofcerAWWAHKvWjWGQtg=";
    };
    open = true;

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
