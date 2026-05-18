{ ns, pkgs, ...}:

ns.enable {
  services.udev.packages = [
    (pkgs.writeTextFile rec {
      name = "99-ad65-no-joystick.rules";
      destination = "/lib/udev/rules.d/${name}";
      checkPhase = ''
        ${pkgs.systemd}/bin/udevadm verify $out/lib/udev/rules.d/${name}
      '';
      text = ''
        SUBSYSTEM=="input", ATTRS{idVendor}=="7074", ATTRS{idProduct}=="0010", ENV{ID_INPUT_JOYSTICK}=""
      '';
    })
  ];
}
