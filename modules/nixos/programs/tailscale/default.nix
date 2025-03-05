{ config, lib, ... }:

with lib;
let
  inherit (namespace config { nixos.programs.tailscale = ns; }) cfg opt;
  admins = getAdmins config.custom.common.opts.host.users;
in
{
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
