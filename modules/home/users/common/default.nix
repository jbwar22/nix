{ inputs, lib, config, ... }:

with lib; {
  imports = [
    inputs.agenix.homeManagerModules.default
    ../../../common
    ../..
  ];

  config = {
    age = {
      secrets = loadAgeSecretsFromDir ../../../../secrets/agenix/users/${config.home.username}/common;
    };
  };
}
