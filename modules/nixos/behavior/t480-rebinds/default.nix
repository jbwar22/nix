{ ns, ...}:

ns.enable {
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

  # environment.etc."libinput/local-overrides.quirks".text = lib.mkForce ''
    # [Serial Keyboards]
    # MatchUdevType=keyboard
    # MatchName=keyd virtual keyboard
    # AttrKeyboardIntegration=internal
  # '';
}
