{ config, lib, pkgs, inputs, ... }:

with lib; with namespace config { nixos.host = ns; }; {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ../..
    ../../../common
  ];

  options = opt (mkSubmoduleOption "basic host setup" {
    hostname = mkStrOption "system hostname";
    system = mkStrOption "system";
    os = mkStrOption "os";
    users = mkOption {
      description = "users on the system";
      default = {};
      type = with types; attrsOf (submodule {
        options = {
          admin = mkEnableOption "the user being an admin";
        };
      });
    };
  });

  config = {
    # create user accounts
    users.users = mapAttrs (username: user: {
      isNormalUser = true;
      extraGroups = mkIf user.admin [ "wheel" ];
    }) cfg.users;

    # load host common options into home-manager
    home-manager = setHMOpt cfg.users {
      custom.common = config.custom.common;
    };

    # load common suite
    custom.nixos.suites.common.enable = true; 

    # TMP overlay check!
    environment.systemPackages = with pkgs; [
      vim-test
    ];
  };
}
