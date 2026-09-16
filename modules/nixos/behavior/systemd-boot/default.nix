{ lib, ns, ... }:

let
  inherit (ns)
  cfg
  ecfg
  eopt;
  inherit (lib)
  mkEnableOption
  mkIf;
in {
  options = eopt {
    fixResolution = mkEnableOption "consolemode -> auto";
  };

  config = ecfg {
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
