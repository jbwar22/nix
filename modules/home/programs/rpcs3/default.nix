{ pkgs, ns, ... }:

ns.enable {
  home.packages = with pkgs; [
    rpcs3
  ];

  custom.home.behavior.impermanence.paths = [
    ".config/rpcs3"
    { path = ".cache/rpcs3"; origin = "local"; }
  ];
}
