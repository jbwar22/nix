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

    boot.initrd = {
      availableKernelModules = [ "nvme" "xhci_pci" "thunderbolt" "usbhid" "usb_storage" "sd_mod" ];

      luks.devices."root" = {
        device = "/dev/disk/by-uuid/41c4368d-eb26-45c7-ba3d-06c87e50ceda";
        bypassWorkqueues = true;
      };
    };

    fileSystems."/" =
      { device = "/dev/disk/by-uuid/b2dc4ba3-1dc1-4294-a842-4b1e151a54bf";
        fsType = "btrfs";
        options = [ "subvol=@root" "noatime" "compress=lzo" "ssd" "space_cache=v2" ];
      };

    fileSystems."/toplevel" =
      { device = "/dev/disk/by-uuid/b2dc4ba3-1dc1-4294-a842-4b1e151a54bf";
        fsType = "btrfs";
        options = [ "subvol=/" "noatime" "compress=lzo" "ssd" "space_cache=v2" ];
      };

    fileSystems."/persist" =
      { device = "/dev/disk/by-uuid/b2dc4ba3-1dc1-4294-a842-4b1e151a54bf";
        fsType = "btrfs";
        neededForBoot = true;
        options = [ "subvol=@persist" "noatime" "compress=lzo" "ssd" "space_cache=v2" ];
      };

    fileSystems."/boot/efi" =
      { device = "/dev/disk/by-uuid/0A74-81F6";
        fsType = "vfat";
        options = [ "umask=0077" "defaults" ];
      };

    fileSystems."/nix" =
      { device = "/dev/disk/by-uuid/b2dc4ba3-1dc1-4294-a842-4b1e151a54bf";
        fsType = "btrfs";
        options = [ "subvol=@nix" "noatime" "compress=lzo" "ssd" "space_cache=v2" ];
      };

    # fileSystems."/home" =
    #   { device = "/dev/disk/by-uuid/b2dc4ba3-1dc1-4294-a842-4b1e151a54bf";
    #     fsType = "btrfs";
    #     options = [ "subvol=@home" "noatime" "compress=lzo" "ssd" "space_cache=v2" ];
    #   };

    swapDevices = [ ];

    custom.common = {
      opts.hardware = {
        cpu.threads = 16;
        memory.size = 32;
        batteries = {
          BAT1 = {
            max = 80;
          };
        };
      };
    };
  };
}
