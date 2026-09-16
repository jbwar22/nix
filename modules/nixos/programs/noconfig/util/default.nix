{ pkgs, ns, ... }:

let
  inherit (pkgs)
  git-crypt;
in ns.enable {
  environment.systemPackages = [
    git-crypt   # needed for using this repo
  ];
}
