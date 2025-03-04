{ lib, config, ... }:

with lib; {
  config = {
    home.username = "jackson";

    custom.home = {
      suites = {
        common.enable = true;
        gaming.enable = true;
        japanese.enable = true;
        sway.enable = true;
      };

      programs = {
        fcitx5.user-dictionary = ageOrNull config "fcitx5-mozc-user_dictionary";
      };
    };

    age = {
      secrets = {
        fcitx5-mozc-user_dictionary.file = ../../../../secrets/agenix/users/jackson/common/fcitx5-mozc-user_dictionary.age;
      };
    };
  };
}
