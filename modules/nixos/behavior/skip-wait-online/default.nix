{ config, lib, ... }:

with lib; with namespace config { nixos.behavior.skip-wait-online = ns; }; {
  # enable if having issues with network manager wait online
  options = opt {
    enable = mkEnableOption "Whether to skip waiting for network online";
  };
  config = lib.mkIf cfg.enable {
    systemd.network.wait-online.enable = false;
    boot.initrd.systemd.network.wait-online.enable = false;
  };
}
