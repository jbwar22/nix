{ config, lib, ...}:

with lib; with ns config ./.; {
  options = opt {
    enable = mkEnableOption "rebound keybinds for broken t480 keyboard";
  };

  config = mkIf cfg.enable {
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
  };
}
