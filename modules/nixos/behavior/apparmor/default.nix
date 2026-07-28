{ ns, pkgs, ...}:

ns.enable {
  security.apparmor = {
    enable = true;
    packages = [ pkgs.apparmor-profiles ];
  };
}
