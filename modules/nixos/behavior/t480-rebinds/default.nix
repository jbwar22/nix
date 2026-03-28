{ config, lib, ns, ...}:

with lib; ns.enable {
  services.keyd = {
    enable = true;
    keyboards.default.settings = {
      main = {
        pagedown = "right";
        sysrq = "layer(fn2)";
      };
      fn2 = {
        pageup = "pagedown";
      };
    };
  };
}
