{ config, lib, ... }:

with lib; mkNsEnableModule config ./. {
  services.openssh = {
    enable = true;
    settings = {
      X11Forwarding = true;
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  networking.firewall.allowedTCPPorts = [ 22 ];

  # in main module because host key is needed for agenix
  # environment.persistence = persistSysDirs config [ "/etc/ssh" ];
}
