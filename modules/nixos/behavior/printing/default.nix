{ lib, ns, ... }:

let
  inherit (lib)
  mkDefault;
in ns.enable {
  services.printing.enable = true;
  services.avahi = {
    enable = mkDefault true;
    nssmdns4 = mkDefault true;
    openFirewall = mkDefault true;
  };
}
