{ inputs, config, lib, modulesPath, ... }:

with lib; with ns config ./.; {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  options = opt {
    enable = mkEnableOption "lenovo t480 hardware configuration";
  };

  config = lib.mkIf cfg.enable {
    custom.nixos.hardware.cpu.intel.enable = true;

    # nixos-hardware overrides
    hardware.cpu.intel.updateMicrocode = false;
    services.fstrim.enable = false;

    boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "sd_mod" ];

    boot.kernel.sysctl."vm.swapiness" = 0;

    fileSystems."/" =
      { device = "/dev/disk/by-uuid/46f5a669-adab-462d-ba14-6f1282a06bc5";
        fsType = "btrfs";
        options = [ "subvol=@root" "subvolid=256" "noatime" "compress=lzo" "ssd" "space_cache=v2" ];
      };

    boot.initrd.luks.devices."root".device = "/dev/disk/by-uuid/c9a1bcf9-6e95-4e1c-a244-d8314c3009e9";

    fileSystems."/home" =
      { device = "/dev/disk/by-uuid/46f5a669-adab-462d-ba14-6f1282a06bc5";
        fsType = "btrfs";
        options = [ "subvol=@home" "subvolid=258" "noatime" "compress=lzo" "ssd" "space_cache=v2" ];
      };

    fileSystems."/toplevel" =
      { device = "/dev/disk/by-uuid/46f5a669-adab-462d-ba14-6f1282a06bc5";
        fsType = "btrfs";
        options = [ "subvol=/" "subvolid=5" "noatime" "compress=lzo" "ssd" "space_cache=v2" ];
      };

    fileSystems."/home/jackson/bulk" =
      { device = "/dev/disk/by-uuid/46f5a669-adab-462d-ba14-6f1282a06bc5";
        fsType = "btrfs";
        options = [ "subvol=@bulk" "subvolid=257" "noatime" "compress=lzo" "ssd" "space_cache=v2" ];
      };

    fileSystems."/boot" =
      { device = "/dev/disk/by-uuid/7892-12B5";
        fsType = "vfat";
        options = [ "umask=0077" "defaults" ];
      };

    swapDevices = [ ];

    custom.common = {
      opts.hardware = {
        cpu.threads = 8;
        memory.size = 32;
        batteries = {
          BAT0 = {
            min = 50;
            max = 70;
          };
          BAT1 = {
            min = 75;
            max = 80;
          };
        };
      };
    };
  };
}
