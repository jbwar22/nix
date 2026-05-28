{ inputs, config, lib, pkgs, ns, ... }:

with lib; ns.enable (let
  mkDriver = config.boot.kernelPackages.nvidiaPackages.mkDriver;

  mkUnstableDriver = branch: pipe inputs.nixpkgs-unstable [
    (x: x + "/pkgs/os-specific/linux/nvidia-x11/default.nix")
    readFile
    (splitString "${branch} = generic {")
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
    mkDriver
  ];

  driver-580-142 = mkDriver {
    version = "580.142";
    sha256_64bit = "sha256-IJFfzz/+icNVDPk7YKBKKFRTFQ2S4kaOGRGkNiBEdWM=";
    sha256_aarch64 = "sha256-jntr88SpTYR648P1rizQjB/8KleBoa14Ay12vx8XETM=";
    openSha256 = "sha256-v968LbRqy8jB9+yHy9ceP2TDdgyqfDQ6P41NsCoM2AY=";
    settingsSha256 = "sha256-BnrIlj5AvXTfqg/qcBt2OS9bTDDZd3uhf5jqOtTMTQM=";
    persistencedSha256 = "sha256-il403KPFAnDbB+dITnBGljhpsUPjZwmLjGt8iPKuBqw=";
  };

  # define drivers
  stagingDriver = mkUnstableDriver "production";
  stableDriver = driver-580-142;
in {

  specialisation.nvidia-staging.configuration = {
    environment.etc.specialisation.text = "NVIDIA staging";
    hardware.nvidia.package = mkForce stagingDriver;
  };

  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    package = stableDriver;
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
})
