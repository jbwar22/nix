{ config, lib, ns, ... }:

with lib; ns.enable {
  programs.tmux = {
    enable = true;
    clock24 = true;
    mouse = true;
    prefix = "C-a";
    baseIndex = 1;
  };
}
