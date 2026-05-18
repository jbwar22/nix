{ ns, ... }:

ns.enable {
  custom.nixos = {
    behavior = {
      ad65-keyboard-not-joystick.enable = true;
      appimage.enable = true;
      earlyoom.enable = true;
      flakes-support.enable = true;
      greeter.enable = true;
      journal-management.enable = true;
      locale.enable = true;
      network.enable = true;
      nix.enable = true;
      skip-wait-online.enable = true;
      time.enable = true;
      upower.enable = true;
      zswap.enable = true;
    };

    programs = {
      noconfig.tui.enable = true;
      noconfig.util.enable = true;

      ssh.enable = true;
      tailscale.enable = true;
      vnstat.enable = true;
    };

    reactive = {
      common.enable = true;
      home.enable = true;
    };
  };
}
