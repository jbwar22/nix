{ pkgs, ns, ... }:

ns.enable {
  environment.systemPackages = with pkgs; [
    git-crypt   # needed for using this repo
  ];
}
