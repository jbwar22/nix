{ config, lib, ... }:

with lib;
let
  inherit (namespace config { nixos.programs.home.fcitx5 = ns; }) cfg opt;
in
{
  options = opt {
    enable = mkEnableOption "required system options for home fcitx5";
  };

  config = lib.mkIf cfg.enable {
    services.xserver.desktopManager.runXdgAutostartIfNone = mkDefault true;
  };
}
