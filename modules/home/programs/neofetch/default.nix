{ config, lib, pkgs, ... }:

with lib; mkNsEnableModule config ./. {
  home.packages = with pkgs; [
    neofetch
  ];

  xdg.configFile."neofetch/config.conf" = {
    text = ''
      print_info() {
          info title
          info underline

          info "OS" distro
          info "Kernel" kernel
          info underline

          info "Host" model
          info "CPU" cpu
          info "GPU" gpu
          info "Memory" memory
          info underline

          info "WM" wm
          info "Resolution" resolution
          info "Terminal" term
          info "Shell" shell
          info underline

          info "Uptime" uptime
          info "Packages" packages

          info cols
      }
    '';
  };
}
