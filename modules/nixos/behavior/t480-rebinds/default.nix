{ config, lib, ...}:

with lib; with namespace config { nixos.behavior.t480-rebinds = ns; }; {
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
