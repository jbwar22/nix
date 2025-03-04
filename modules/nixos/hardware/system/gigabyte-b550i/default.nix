{ inputs, config, lib, modulesPath, ... }:

with lib;
let
  inherit (namespace config { nixos.hardware.system.gigabyte-b550i = ns; }) cfg opt;
in
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    inputs.nixos-hardware.nixosModules.gigabyte-b550
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
        options = [ "subvol=@root" "subvolid=256" "noatime" "compress=lzo" "ssd" "space_cache=v2" ];
      };

    fileSystems."/toplevel" =
      { device = "/dev/disk/by-uuid/4cdc67ca-2aa2-4a1b-b929-8c25d041cd35";
        fsType = "btrfs";
        options = [ "subvol=/" "subvolid=5" "noatime" "compress=lzo" "ssd" "space_cache=v2" ];
      };

    fileSystems."/boot" =
      { device = "/dev/disk/by-uuid/4cdc67ca-2aa2-4a1b-b929-8c25d041cd35";
        fsType = "btrfs";
        options = [ "subvol=@boot" "subvolid=259" "noatime" "compress=lzo" "ssd" "space_cache=v2" "umask=0077" ];
      };

    fileSystems."/boot/efi" =
      { device = "/dev/disk/by-uuid/15E9-B97A";
        fsType = "vfat";
        options = [ "umask=0077" "defaults" ];
      };

    fileSystems."/home" =
      { device = "/dev/disk/by-uuid/4cdc67ca-2aa2-4a1b-b929-8c25d041cd35";
        fsType = "btrfs";
        options = [ "subvol=@home" "subvolid=257" "noatime" "compress=lzo" "ssd" "space_cache=v2" ];
      };

    fileSystems."/home/jackson/tmp" =
      { device = "/dev/disk/by-uuid/4cdc67ca-2aa2-4a1b-b929-8c25d041cd35";
        fsType = "btrfs";
        options = [ "subvol=@bulk" "subvolid=258" "noatime" "compress=lzo" "ssd" "space_cache=v2" ];
      };

    fileSystems."/mnt/red" =
      { device = "/dev/disk/by-uuid/5de41f95-30e5-4ffd-bd13-1794796e7971";
        fsType = "ext4";
        options = [ "noatime" ];
      };

    fileSystems."/mnt/arch" =
      { device = "/dev/disk/by-uuid/412c4acc-2414-4f2e-b144-c8a3d70ca14b";
        fsType = "btrfs";
        options = [ "subvol=/" "subvolid=5" "noatime" "ssd" "space_cache=v2" ];
      };

    fileSystems."/mnt/arch/efi" =
      { device = "/dev/disk/by-uuid/5A6D-745F";
        fsType = "vfat";
        options = [ "rw" "noatime" "fmask=0022" "dmask=0022" "codepage=437" "iocharset=ascii" "shortname=mixed" "utf8" "errors=remount-ro" ];
      };

    swapDevices = [ ];

    custom.common = {
      opts.hardware = {
        cpu.threads = 8;
        memory.size = 32;
        nvidia = true;
      };
    };
  };
}
