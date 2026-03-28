{ config, ns, ... }:

ns.enable {
  home.file."bulk".source = config.lib.file.mkOutOfStoreSymlink "/bulk/${config.home.username}";
}
