{ inputs, config, lib, pkgs, ns, ... }:

with lib; ns.enable {
  specialisation.lts.configuration = let
    kernelPackages = pkgs.linuxPackages_6_12;
  in {
    environment.etc.specialisation.text = "6.12, NVIDIA latest 565";
    boot.kernelPackages = mkForce kernelPackages;
    hardware.nvidia.package = mkForce kernelPackages.nvidiaPackages.latest;
  };

  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = let
    driverAttrsParsed = pipe inputs.nixpkgs-unstable [
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
    driverAttrsDefined = {
      version = "580.142";
      sha256_64bit = "sha256-IJFfzz/+icNVDPk7YKBKKFRTFQ2S4kaOGRGkNiBEdWM=";
      sha256_aarch64 = "sha256-jntr88SpTYR648P1rizQjB/8KleBoa14Ay12vx8XETM=";
      openSha256 = "sha256-v968LbRqy8jB9+yHy9ceP2TDdgyqfDQ6P41NsCoM2AY=";
      settingsSha256 = "sha256-BnrIlj5AvXTfqg/qcBt2OS9bTDDZd3uhf5jqOtTMTQM=";
      persistencedSha256 = "sha256-il403KPFAnDbB+dITnBGljhpsUPjZwmLjGt8iPKuBqw=";
    };
    driverAttrs = driverAttrsDefined;
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
