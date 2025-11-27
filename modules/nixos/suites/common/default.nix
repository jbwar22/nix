{ config, lib, ... }:

with lib; mkNsEnableModule config ./. {
  custom.nixos = {
    behavior = {
      appimage.enable = true;
      flakes-support.enable = true;
      locale.enable = true;
      network.enable = true;
      time.enable = true;
      journal-management.enable = true;
      nix.enable = true;
      greeter.enable = true;
    };

    programs = {
      noconfig.util.enable = true;
      noconfig.tui.enable = true;
      ssh.enable = true;
      tailscale.enable = true;
      vnstat.enable = true;
    };

    reactive = {
      common.enable = true;
      home.enable = true;
    };
  };
}
