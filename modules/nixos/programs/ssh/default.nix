{ config, lib, ... }:

with lib; with namespace config { nixos.programs.ssh = ns; }; {
  options = opt {
    enable = mkEnableOption "ssh server";
  };

  config = lib.mkIf cfg.enable {

    services.openssh = {
      enable = true;
      settings = {
        X11Forwarding = true;
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
    };

    networking.firewall.allowedTCPPorts = [ 22 ];

  };
}
