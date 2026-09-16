{ pkgs, ns, ... }:

ns.enable {
  environment.systemPackages = [
    pkgs.git-crypt   # needed for using this repo
  ];
}
