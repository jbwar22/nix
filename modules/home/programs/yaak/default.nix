{ pkgs, ns, ... }:

ns.enable {
  home.packages = [
    pkgs.yaak
  ];

  custom.home.behavior.impermanence.paths = [
    ".local/share/app.yaak.desktop"   # actual defined endpoints
    # ".config/app.yaak.desktop"      # ok to just wipe window config
    # ".local/share/yaak-app"         # not needed
  ];
}
