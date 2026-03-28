{ pkgs, ns, ... }:

ns.enable {
  home.packages = with pkgs; [
    ente-auth
  ];

  custom.home.behavior.impermanence.paths = [
    ".local/share/io.ente.auth"
  ];
}
