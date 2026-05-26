{ pkgs, ns, ... }:

ns.enable {
  services.swayidle = {
    enable = true;
    events = {
      "before-sleep" = "${pkgs.swaylock}/bin/swaylock";
    };
  };
}
