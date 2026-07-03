{ ns, ...}:

ns.enable {
  boot.kernel.sysctl."kernel.sysrq" = 1;
}
