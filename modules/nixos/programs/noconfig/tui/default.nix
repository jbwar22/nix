{ pkgs, ns, ... }:

ns.enable {
  environment.systemPackages = [
    pkgs.vim
  ];
}
