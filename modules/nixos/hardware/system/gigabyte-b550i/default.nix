{ inputs, config, lib, modulesPath, ... }:

with lib; with ns config ./.; {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  options = opt {
    enable = mkEnableOption "gigabyte b550i hardware configuration";
  };

  config = lib.mkIf cfg.enable {
    custom.nixos.hardware.cpu.amd.enable = true;

    custom.nixos.behavior.impermanence = {
      enable = true;
      device = "/dev/disk/by-uuid/5d351eb3-6fc5-4d3d-a4cb-42904a48d439";
      mntOptions = [ "noatime" "compress=lzo" "ssd" "space_cache=v2" ];
    };

    boot.initrd = {
      availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];

      luks.devices."root" = {
        device = "/dev/disk/by-uuid/bf17b001-806a-4773-b3f9-862597fb3c87";
        bypassWorkqueues = true;
      };
    };

    fileSystems."/" = {
      device = "root_tmpfs";
      fsType = "tmpfs";
      options = [ "defaults" "size=8G" "mode=755" ];
    };

    fileSystems."/boot" =
      { device = "/dev/disk/by-uuid/A550-E7F5";
        fsType = "vfat";
        options = [ "umask=0077" "defaults" ];
      };

    fileSystems."/nix" =
      { device = "/dev/disk/by-uuid/5d351eb3-6fc5-4d3d-a4cb-42904a48d439";
        fsType = "btrfs";
        options = [ "subvol=local/@nix" "noatime" "compress=lzo" "ssd" "space_cache=v2" ];
      };

    fileSystems."/bulk" =
      { device = "/dev/disk/by-uuid/5d351eb3-6fc5-4d3d-a4cb-42904a48d439";
        fsType = "btrfs";
        options = [ "subvol=local/@bulk" "noatime" "compress=lzo" "ssd" "space_cache=v2" ];
      };

    fileSystems."/swap" =
      { device = "/dev/disk/by-uuid/5d351eb3-6fc5-4d3d-a4cb-42904a48d439";
        fsType = "btrfs";
        options = [ "subvol=local/@swap" "noatime" "compress=lzo" "ssd" "space_cache=v2" ];
      };

    swapDevices = [{
      device = "/swap/swapfile";
      size = 8 * 1024;
    }];

    boot.kernel.sysctl."vm.swapiness" = 1;

    # Additional Filesystems

    fileSystems."/mnt/red" =
      { device = "/dev/disk/by-uuid/5de41f95-30e5-4ffd-bd13-1794796e7971";
        fsType = "ext4";
        options = [ "noatime" ];
      };

    fileSystems."/mnt/arch" =
      { device = "/dev/disk/by-uuid/412c4acc-2414-4f2e-b144-c8a3d70ca14b";
        fsType = "btrfs";
        options = [ "subvol=/" "noatime" "ssd" "space_cache=v2" ];
      };

    fileSystems."/mnt/nix1" =
      { device = "/dev/disk/by-uuid/4cdc67ca-2aa2-4a1b-b929-8c25d041cd35";
        fsType = "btrfs";
        options = [ "subvol=/" "noatime" "compress=lzo" "ssd" "space_cache=v2" ];
      };

    fileSystems."/mnt/arch/efi" =
      { device = "/dev/disk/by-uuid/5A6D-745F";
        fsType = "vfat";
        options = [ "rw" "noatime" "fmask=0022" "dmask=0022" "codepage=437" "iocharset=ascii" "shortname=mixed" "utf8" "errors=remount-ro" ];
      };

    custom.common = {
      opts.hardware = {
        cpu = {
          vendor = enums.cpu-vendors.amd;
          threads = 12;
        };
        memory.size = 32;
        gpu.vendor = enums.gpu-vendors.nvidia;
        interface.wifi = "wlp6s0";
        interface.ethernet = "eno1";
      };
    };
  };
}
