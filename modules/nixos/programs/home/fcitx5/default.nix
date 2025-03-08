{ config, lib, ... }:

with lib; with namespace config { nixos.programs.home.fcitx5 = ns; }; {
  options = opt {
    enable = mkEnableOption "required system options for home fcitx5";
  };

  config = lib.mkIf cfg.enable {
    services.xserver.desktopManager.runXdgAutostartIfNone = mkDefault true;
  };
}
