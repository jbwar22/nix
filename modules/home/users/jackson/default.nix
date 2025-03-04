{ config, ... }:

{
  config = {
    home.username = "jackson";

    custom.home = {
      suites = {
        common.enable = true;
        gaming.enable = true;
        japanese.enable = true;
        sway.enable = true;
      };
    };

    age = {
      identityPaths = [ "${config.home.homeDirectory}/.ssh/id_rsa" ];
      secrets = {
        geolocation.file = ../../../../secrets/agenix/users/jackson/monstro/geolocation.age;
      };
    };
  };
}
