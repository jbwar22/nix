{ config, lib, pkgs, ... }:

with lib;
let
  inherit (namespace config { nixos.behavior.nvidia = ns; }) cfg opt;
  users = config.custom.nixos.host.users;
in
{
  options = opt {
    enable = mkEnableOption "options required for nvidia hardware";
  };

  config = lib.mkIf cfg.enable {

    services.xserver.videoDrivers = ["nvidia"];

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
  };
}
