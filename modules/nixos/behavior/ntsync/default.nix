{ ns, clib, pkgs, ...}:

ns.enable {
  boot.kernelModules = [ "ntsync" ];

  services.udev.packages = [
    (clib.writeUdevFile pkgs "ntsync-udev-rules" 70 ''
      KERNEL=="ntsync", MODE="0660", TAG+="uaccess"
    '')
  ];
}
