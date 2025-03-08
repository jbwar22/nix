{ config, lib, ... }:

with lib; with namespace config { nixos.programs.tailscale = ns; }; let
  admins = getAdmins config.custom.common.opts.host.users;
in {
  options = opt {
    enable = mkEnableOption "tailscale";
  };

  config = mkIf cfg.enable {

    services.tailscale.enable = true;

    services.davfs2 = {
      enable = true;
    };

    users = setUserGroups admins [ "davfs2" ];

  };
}
