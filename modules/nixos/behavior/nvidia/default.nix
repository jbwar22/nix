{ inputs, config, lib, pkgs, ... }:

with lib; mkNsEnableModule config ./. {
  specialisation.lts.configuration = let
    kernelPackages = pkgs.linuxPackages_6_12;
  in {
    environment.etc.specialisation.text = "6.12, NVIDIA latest 565";
    boot.kernelPackages = mkForce kernelPackages;
    hardware.nvidia.package = mkForce kernelPackages.nvidiaPackages.latest;
  };

  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = let
    # currently broken: production has a conditional version
    # driverAttrs = pipe inputs.nixpkgs-unstable [
    #   (x: x + "/pkgs/os-specific/linux/nvidia-x11/default.nix")
    #   readFile
    #   (splitString "production = generic {")
    #   last
    #   (splitString "};")
    #   head
    #   trim
    #   (splitString "\n")
    #   (map (x: pipe x [
    #     trim
    #     (splitString " = ")
    #     (x: {
    #       name = head x;
    #       value = pipe x [
    #         last
    #         (removePrefix "\"")
    #         (removeSuffix "\";")
    #       ];
    #     })
    #   ]))
    #   listToAttrs
    # ];
    driverAttrs = {
      version = "580.105.08";
      sha256_64bit = "sha256-2cboGIZy8+t03QTPpp3VhHn6HQFiyMKMjRdiV2MpNHU=";
      openSha256 = "sha256-FGmMt3ShQrw4q6wsk8DSvm96ie5yELoDFYinSlGZcwQ=";
      settingsSha256 = "sha256-YvzWO1U3am4Nt5cQ+b5IJ23yeWx5ud1HCu1U0KoojLY=";
      persistencedSha256 = "sha256-qh8pKGxUjEimCgwH7q91IV7wdPyV5v5dc5/K/IcbruI=";
    };
  in {
    package = config.boot.kernelPackages.nvidiaPackages.mkDriver driverAttrs;
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
