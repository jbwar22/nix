{ config, lib, ... }:

with lib; with ns config ./.; {
  options = opt {
    enable = mkEnableOption "tmux";
  };

  config = mkIf cfg.enable {
    programs.tmux = {
      enable = true;
      clock24 = true;
      mouse = true;
      prefix = "C-a";
      baseIndex = 1;
    };
  };
}
