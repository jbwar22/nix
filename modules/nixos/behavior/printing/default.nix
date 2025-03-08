{ config, lib, ... }:

with lib; with namespace config { nixos.behavior.printing = ns; }; {
  options = opt {
    enable = mkEnableOption "Whether to enable printing support";
  };
  config = lib.mkIf cfg.enable {
    services.printing.enable = true;
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
  };
}
