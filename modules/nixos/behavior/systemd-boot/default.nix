{ lib, ns, ... }:

with lib; with ns; {
  options = eopt {
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
