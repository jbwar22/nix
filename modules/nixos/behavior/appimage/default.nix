{ config, lib, ns, ... }:

with lib; ns.enable {
  programs.appimage.binfmt = true;
}
