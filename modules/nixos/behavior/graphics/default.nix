{ pkgs, ns, ... }:

ns.enable {
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  environment.systemPackages = with pkgs; [
    dconf  # gtk
    vulkan-tools
  ];
}
