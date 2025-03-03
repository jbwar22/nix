{ config, lib, ...}:

with lib;
let
  inherit (namespace config { nixos.behavior.t480-rebinds = ns; }) cfg opt;
in
{
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
