{ inputs, lib, clib, config, osConfig, ... }:

{
  imports = [
    inputs.agenix.homeManagerModules.default
    ../../../common
    ../..
  ];

  config = {
    custom.common = osConfig.custom.common; # TODO unsafe on standalone hm on non nixos systems
    home.homeDirectory = lib.mkDefault "/home/${config.home.username}";
    age = with clib; {
      secrets = (
        loadAgeSecretsFromDir ../../../../secrets/agenix/users/${config.home.username}/common
      ) // ( 
        loadAgeSecretsFromDir ../../../../secrets/agenix/users/${config.home.username}/${config.custom.common.opts.host.hostname}
      );
    };
  };
}
