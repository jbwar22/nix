{ config, lib, pkgs, outputs, ns, ... }:

with lib; ns.enable {
  home.packages = [
    outputs.packages.${pkgs.stdenv.hostPlatform.system}.nixvim
  ];

  custom.home.behavior.impermanence.paths = [
    ".local/state/nvim" # includes swp
    # ".local/share/nvim"
    # ".cache/nvim"
  ];
}
