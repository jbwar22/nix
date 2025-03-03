{ config, lib, ... }:

with lib;
let
  inherit (namespace config { home.programs.tmux = ns; }) cfg opt;
in
{
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
