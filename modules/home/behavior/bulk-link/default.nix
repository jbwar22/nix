{ config, lib, pkgs, ns, ... }:

with lib; ns.enable {
  home.file."bulk".source = config.lib.file.mkOutOfStoreSymlink "/bulk/${config.home.username}";
}
