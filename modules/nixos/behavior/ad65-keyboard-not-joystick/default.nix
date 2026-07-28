{ ns, clib, pkgs, ...}:

ns.enable {
  services.udev.packages = [
    (clib.writeUdevFile pkgs "ad65-no-joystick" 99 ''
        SUBSYSTEM=="input", ATTRS{idVendor}=="7074", ATTRS{idProduct}=="0010", ENV{ID_INPUT_JOYSTICK}=""
    '')
  ];
}
