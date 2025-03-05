{ config, lib, pkgs, inputs, ... }:

with lib; {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    inputs.agenix.nixosModules.default
    ../..
    ../../../common
  ];

  config = let
    users = config.custom.common.opts.host.users;
  in {
    # create user accounts
    users.users = mapAttrs (username: user: {
      isNormalUser = true;
      extraGroups = mkIf user.admin [ "wheel" ];
    }) users;

    # load host common options into home-manager
    home-manager = setHMOptWithUser users (username: {
      custom.common = config.custom.common;
      home.username = mkDefault username;
      home.homeDirectory = mkDefault "/home/${username}";
    });

    # load common suite
    custom.nixos.suites.common.enable = true; 

    # TMP overlay check!
    environment.systemPackages = with pkgs; [
      vim-test
    ];
  };
}
