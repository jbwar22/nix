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
      version = "580.65.06";
      sha256_64bit = "sha256-BLEIZ69YXnZc+/3POe1fS9ESN1vrqwFy6qGHxqpQJP8=";
      sha256_aarch64 = "sha256-4CrNwNINSlQapQJr/dsbm0/GvGSuOwT/nLnIknAM+cQ=";
      openSha256 = "sha256-BKe6LQ1ZSrHUOSoV6UCksUE0+TIa0WcCHZv4lagfIgA=";
      settingsSha256 = "sha256-9PWmj9qG/Ms8Ol5vLQD3Dlhuw4iaFtVHNC0hSyMCU24=";
      persistencedSha256 = "sha256-ETRfj2/kPbKYX1NzE0dGr/ulMuzbICIpceXdCRDkAxA=";
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
