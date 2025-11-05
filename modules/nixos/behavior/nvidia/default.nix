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
    parsedDriverAttrs = pipe inputs.nixpkgs-unstable [
      (x: x + "/pkgs/os-specific/linux/nvidia-x11/default.nix")
      readFile
      (splitString "production = generic {")
      last
      (splitString "};")
      head
      trim
      (splitString "\n")
      (map (x: pipe x [
        trim
        (splitString " = ")
        (x: {
          name = head x;
          value = pipe x [
            last
            (removePrefix "\"")
            (removeSuffix "\";")
          ];
        })
      ]))
      listToAttrs
    ];
  in {
    package = config.boot.kernelPackages.nvidiaPackages.mkDriver parsedDriverAttrs;
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
