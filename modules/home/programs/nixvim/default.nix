{ pkgs, self, ns, ... }:

ns.enable {
  home.packages = [
    self.packages.${pkgs.stdenv.hostPlatform.system}.nixvim
  ];

  custom.home.behavior.impermanence.paths = [
    ".local/state/nvim" # includes swp
    # ".local/share/nvim"
    # ".cache/nvim"
  ];
}
