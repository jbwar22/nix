{ inputs, config, lib, modulesPath, ... }:

with lib; with ns config ./.; {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  options = opt {
    enable = mkEnableOption "framework 13 hardware configuration";
  };

  config = lib.mkIf cfg.enable {
    custom.nixos.hardware.cpu.amd.enable = true;
    custom.nixos.behavior.impermanence = { # sets up most mounts
      enable = true;
      device = "/dev/disk/by-uuid/b2dc4ba3-1dc1-4294-a842-4b1e151a54bf";
      mntOptions = [ "noatime" "compress=lzo" "ssd" "space_cache=v2" ];
      # persist = "@new_persist";
    };

    boot.kernelParams = [
      # "amdgpu.dcdebugmask=0x410" # potential flicker fix (old)
      # "amdgpu.dcdebugmask=0x2" # potential flicker fix (new)
    ];

    # https://gitlab.freedesktop.org/drm/amd/-/issues/4463#note_3167900
    boot.kernelPatches = [{
      name = "fix flicker";
      patch = ./drm-amd-fix-flicker.patch;
    }];

    specialisation.base-kernel.configuration = {
      boot.kernelPatches = mkForce [];
    };

    boot.initrd = {
      availableKernelModules = [ "nvme" "xhci_pci" "thunderbolt" "usbhid" "usb_storage" "sd_mod" ];

      luks.devices."root" = {
        device = "/dev/disk/by-uuid/41c4368d-eb26-45c7-ba3d-06c87e50ceda";
        bypassWorkqueues = true;
      };
    };

    fileSystems."/" = { 
      device = "root_tmpfs";
      fsType = "tmpfs";
      options = [ "defaults" "size=8G" "mode=755" ];
    };

    fileSystems."/toplevel" =
      { device = "/dev/disk/by-uuid/b2dc4ba3-1dc1-4294-a842-4b1e151a54bf";
        fsType = "btrfs";
        options = [ "subvol=/" "noatime" "compress=lzo" "ssd" "space_cache=v2" ];
      };

    fileSystems."/boot" =
      { device = "/dev/disk/by-uuid/0A74-81F6";
        fsType = "vfat";
        options = [ "umask=0077" "defaults" ];
      };

    fileSystems."/nix" =
      { device = "/dev/disk/by-uuid/b2dc4ba3-1dc1-4294-a842-4b1e151a54bf";
        fsType = "btrfs";
        options = [ "subvol=@nix" "noatime" "compress=lzo" "ssd" "space_cache=v2" ];
      };

    fileSystems."/swap" =
      { device = "/dev/disk/by-uuid/b2dc4ba3-1dc1-4294-a842-4b1e151a54bf";
        fsType = "btrfs";
        options = [ "subvol=@swap" "noatime" "ssd" ];
      };

    swapDevices = [{
      device = "/swap/swapfile";
      size = 8 * 1024;
    }];

    boot.kernel.sysctl."vm.swapiness" = 1;

    custom.common = {
      opts.hardware = {
        cpu = {
          vendor = enums.cpu-vendors.amd;
          threads = 16;
        };
        memory.size = 32;
        gpu.vendor = enums.gpu-vendors.amd;
        batteries = {
          BAT1 = {
            max = 80;
          };
        };
        interface.wifi = "wlp192s0";
        interface.ethernet = "enp195s0f0u2";
      };
    };
  };
}
