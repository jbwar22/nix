{ clib, config, ... }:

{
  config = {
    custom.home = {
      suites = {
        common.enable = true;
        gaming.enable = true;
        japanese.enable = true;
        sway.enable = true;
      };

      programs = {
        fcitx5.user-dictionary = clib.ageOrNull config "fcitx5-mozc-user_dictionary";
      };

      services = {
        # afuse-sshfs.enable = true;
        afuse-archive.enable = true;
      };
    };
  };
}
