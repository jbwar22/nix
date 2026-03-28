{ pkgs, ns, ... }:

ns.enable {
  home.packages = with pkgs; [
    git
    git-crypt
  ];

  custom.home.behavior.impermanence.paths = [
    { path = ".gitconfig"; file = true; }
  ];
}
