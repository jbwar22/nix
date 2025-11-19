{ inputs, config, lib, ... }:

with lib; with ns config ./.; let
  users = config.custom.common.opts.host.users;
in {
  imports = [
    (inputs.nixpkgs-add-librepods + "/nixos/modules/programs/librepods.nix")
  ];

  options = with types; opt {
    enable = mkEnableOption "plymouth splash screen on boot";
  };

  config = lib.mkIf cfg.enable {
    programs.librepods.enable = true;

    users = setUserGroups users [ "librepods" ];
  };
}

