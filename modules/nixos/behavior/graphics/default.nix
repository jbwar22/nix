{ pkgs, ns, ... }:

ns.enable {
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  environment.systemPackages = [
    pkgs.dconf  # gtk
    pkgs.vulkan-tools
  ];
}
