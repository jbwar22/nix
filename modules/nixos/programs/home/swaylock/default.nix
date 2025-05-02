{ config, lib, ... }:

with lib; mkNsEnableModule config ./. {
  security.pam.services.swaylock = {};
  # security.pam.services.swaylock.fprintAuth = mkIf config.services.fprintd.enable true;
  security.pam.services.swaylock.text = mkIf config.services.fprintd.enable ''
    auth [success=1 default=ignore] pam_succeed_if.so service in sudo:su:su-1 tty in :unknown
    auth sufficient pam_unix.so try_first_pass likeauth nullok
    auth sufficient pam_fprintd.so
    auth include login
  '';
  security.polkit.enable = mkDefault true;
}
