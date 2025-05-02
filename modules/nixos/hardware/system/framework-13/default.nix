{ inputs, config, lib, modulesPath, ... }:

with lib; with ns config ./.; {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  options = opt {
    enable = mkEnableOption "framework 13 hardware configuration";
  };

  config = lib.mkIf cfg.enable {
    # custom.nixos.hardware.cpu.amd.enable = true;

    users.users.root.openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCirJ2siQwyzwawQlL5VSdXdgNUI9As4OzTB99rPWYDZgGrZVWelk57Ekf+8wXJo8tBm5x+LM/2Qjs2krvvdWvqyoytl0bY78OsFb7VgOo1oRuMPnLFrQCKl9tPfzBTd6AMJB7cbe1ioxRvDOSn95PK308oWezW7YGJU8jHNu75leEDiF5PSkF21mGTT0q7coj/N6fdc461MIIJUh/hPxjeh1o6YKZuTcFSuAq0k1r9FrREaye5+tio33hhsgJFwJ/AygeYLnTFdWhPu3UArkyqAKV6y+rQo/rkO7f73FZlg8Pd/3w8GX7e1dQxamH1japdSpSzRcgzazY+/80NlEIM5jQvmNy2HW+S+WwDgkCCLhHXiCi1GOUcRbeQZBVG+gpF0VJ+ISU1Rfr6JNtdkKO/OJXSfav5grIDM3gtc7nvstXrrCNkT+fi8+LTgx/lPCpi9rYYeWCHxOdS/XEPEs/IO3P6wkeS8AOmkORYEOdOC8r3ZssWBYhWzjxeZAfeBjM= jackson@monstro"
    ];
    users.users.jackson.openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCirJ2siQwyzwawQlL5VSdXdgNUI9As4OzTB99rPWYDZgGrZVWelk57Ekf+8wXJo8tBm5x+LM/2Qjs2krvvdWvqyoytl0bY78OsFb7VgOo1oRuMPnLFrQCKl9tPfzBTd6AMJB7cbe1ioxRvDOSn95PK308oWezW7YGJU8jHNu75leEDiF5PSkF21mGTT0q7coj/N6fdc461MIIJUh/hPxjeh1o6YKZuTcFSuAq0k1r9FrREaye5+tio33hhsgJFwJ/AygeYLnTFdWhPu3UArkyqAKV6y+rQo/rkO7f73FZlg8Pd/3w8GX7e1dQxamH1japdSpSzRcgzazY+/80NlEIM5jQvmNy2HW+S+WwDgkCCLhHXiCi1GOUcRbeQZBVG+gpF0VJ+ISU1Rfr6JNtdkKO/OJXSfav5grIDM3gtc7nvstXrrCNkT+fi8+LTgx/lPCpi9rYYeWCHxOdS/XEPEs/IO3P6wkeS8AOmkORYEOdOC8r3ZssWBYhWzjxeZAfeBjM= jackson@monstro"
    ];

    boot.initrd.luks.devices."root".device = "/dev/disk/by-uuid/41c4368d-eb26-45c7-ba3d-06c87e50ceda";

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

    fileSystems."/home" =
      { device = "/dev/disk/by-uuid/b2dc4ba3-1dc1-4294-a842-4b1e151a54bf";
        fsType = "btrfs";
        options = [ "subvol=@home" "noatime" "compress=lzo" "ssd" "space_cache=v2" ];
      };

    swapDevices = [ ];

    custom.common = {
      opts.hardware = {
        cpu.threads = 16;
        memory.size = 32;
        nvidia = false;
      };
    };
  };
}
