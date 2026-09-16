{ pkgs, ns, ... }:

ns.enable {
  home.packages = [
    pkgs.ente-auth
  ];

  custom.home.behavior.impermanence.paths = [
    ".local/share/io.ente.auth"
  ];
}
