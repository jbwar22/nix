{ config, lib, ... }:

with lib; with ns config ./.; {
  options = opt {
    enable = mkEnableOption "systemd-boot";
    fixResolution = mkEnableOption "consolemode -> auto";
  };

  config = mkIf cfg.enable {
    boot.loader = {
      systemd-boot = {
        enable = true;
        consoleMode = mkIf cfg.fixResolution "auto";
      };
      efi = {
        canTouchEfiVariables = true;
      };
    };
  };
}
