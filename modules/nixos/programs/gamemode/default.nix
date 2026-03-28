{ config, lib, ns, ... }:

with lib; ns.enable {
  programs.gamemode.enable = true;
}
