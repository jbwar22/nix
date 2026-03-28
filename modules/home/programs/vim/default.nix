{ pkgs, ns, ... }:

ns.enable {
  home.packages = with pkgs; [
    vim
  ];

  custom.home.behavior.impermanence.paths = [
    { path = ".vimrc"; file = true; } # define in nix?
    # ".viminfo"
  ];
}
