{ ns, ...}:

ns.enable {
  # support only! no defined libraries here.
  # NIX_LD and NIX_LD_LIBRARY_PATH should be set by dev shells as needed.
  programs.nix-ld.enable = true;
}
