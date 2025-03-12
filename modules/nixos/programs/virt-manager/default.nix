{ config, lib, pkgs, ... }:

with lib; with ns config ./.; let
  admins = getAdmins config.custom.common.opts.host.users;
in {
  options = opt {
    enable = mkEnableOption "docker";
  };

  config = lib.mkIf cfg.enable {
    programs.virt-manager.enable = true;
    virtualisation.libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
        ovmf = {
          enable = true;
          packages = [(pkgs.OVMF.override {
            secureBoot = true;
            tpmSupport = true;
          }).fd];
        };
      };
    };
    virtualisation.spiceUSBRedirection.enable = true;

    
    home-manager = setHMOpt admins {
      xdg.configFile."libvert/qeum.conf".text = ''
        nvram = ["/run/libvirt/nix-ovmf/OVMF_CODE.fd:/run/libvirt/nix-ovmf/OVMF_VARS.fd"]
      '';
    };

    users = setUserGroups admins [ "libvirtd" ];

  };
}
