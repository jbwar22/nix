{ config, lib, ... }:

with lib; with namespace config { home.programs.tmux = ns; }; {
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
