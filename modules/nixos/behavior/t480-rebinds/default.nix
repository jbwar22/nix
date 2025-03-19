{ config, lib, ...}:

with lib; mkNsEnableModule config ./. {
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
