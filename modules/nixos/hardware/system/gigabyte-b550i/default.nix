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

    boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];

    fileSystems."/" =
      { device = "/dev/disk/by-uuid/4cdc67ca-2aa2-4a1b-b929-8c25d041cd35";
        fsType = "btrfs";
        options = [ "subvol=@root" "noatime" "compress=lzo" "ssd" "space_cache=v2" ];
      };

    fileSystems."/toplevel" =
      { device = "/dev/disk/by-uuid/4cdc67ca-2aa2-4a1b-b929-8c25d041cd35";
        fsType = "btrfs";
        options = [ "subvol=/" "noatime" "compress=lzo" "ssd" "space_cache=v2" ];
      };

    fileSystems."/boot/efi" =
      { device = "/dev/disk/by-uuid/A550-E7F5";
        fsType = "vfat";
        options = [ "umask=0077" "defaults" ];
      };

    fileSystems."/nix" =
      { device = "/dev/disk/by-uuid/4cdc67ca-2aa2-4a1b-b929-8c25d041cd35";
        fsType = "btrfs";
        options = [ "subvol=@nix" "noatime" "compress=lzo" "ssd" "space_cache=v2" ];
      };

    fileSystems."/home" =
      { device = "/dev/disk/by-uuid/4cdc67ca-2aa2-4a1b-b929-8c25d041cd35";
        fsType = "btrfs";
        options = [ "subvol=@home" "noatime" "compress=lzo" "ssd" "space_cache=v2" ];
      };

    fileSystems."/home/jackson/bulk" =
      { device = "/dev/disk/by-uuid/4cdc67ca-2aa2-4a1b-b929-8c25d041cd35";
        fsType = "btrfs";
        options = [ "subvol=@bulk" "noatime" "compress=lzo" "ssd" "space_cache=v2" ];
      };

    fileSystems."/data" =
      { device = "/dev/disk/by-uuid/4cdc67ca-2aa2-4a1b-b929-8c25d041cd35";
        fsType = "btrfs";
        options = [ "subvol=@data" "noatime" "compress=lzo" "ssd" "space_cache=v2" ];
      };

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

    fileSystems."/mnt/arch/efi" =
      { device = "/dev/disk/by-uuid/5A6D-745F";
        fsType = "vfat";
        options = [ "rw" "noatime" "fmask=0022" "dmask=0022" "codepage=437" "iocharset=ascii" "shortname=mixed" "utf8" "errors=remount-ro" ];
      };

    swapDevices = [ ];

    custom.common = {
      opts.hardware = {
        cpu.threads = 12;
        memory.size = 32;
        nvidia = true;
      };
    };
  };
}
