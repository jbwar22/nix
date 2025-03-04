{ ... }:

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

    age.secrets = {
      geolocation.file = ../../../../secrets/agenix/monstro-jackson-geolocation.age;
    };
  };
}
