{ ns, lib, ... }:

let
  inherit (lib)
  mkForce;
in ns.enable {
  services.clamav = {
    daemon.enable = true;
    updater.enable = true;
  };

  # clamd is activated by a socket, so don't enable it
  systemd.services.clamav-daemon.wantedBy = mkForce [];
}
