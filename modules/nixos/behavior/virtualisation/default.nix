{ config, lib, pkgs, ... }:

with lib; mkNsEnableModule config ./. (let
  admins = getAdmins config.custom.common.opts.host.users;
in {
  # from nixpkgs/nixos/modules/programs/virt-manager.nix
  programs.dconf = {
    profiles.user.databases = [{
      settings = {
        "org/virt-manager/virt-manager/connections" = {
          autoconnect = [ "qemu:///system" ];
          uris = [ "qemu:///system" ];
        };
      };
    }];
  };

  # if efi errors, run (sudo -E virsh edit <machine>) and remove (loader) and (nvram) from (<os firmware='efi'>)
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
      };
    };
    spiceUSBRedirection.enable = true;
  };

  users = setUserGroups admins [ "libvirtd" ];

  custom.nixos.behavior.impermanence.paths = [ "/var/lib/libvirt" ];
})
