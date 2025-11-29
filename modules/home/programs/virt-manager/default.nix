{ config, lib, pkgs, ... }:

with lib; mkNsEnableModule config ./. (let
  hf = config.custom.home.opts.hostfeatures;
in {
  home.packages = warnIf (!(hf.hasLibvirtd)) "enabling virt-manager when libvirtd is not enabled" (with pkgs; [
    virt-manager
  ]);

  xdg.configFile."libvert/qemu.conf".text = ''
    nvram = ["/run/libvirt/nix-ovmf/OVMF_CODE.fd:/run/libvirt/nix-ovmf/OVMF_VARS.fd"]
  '';
})
