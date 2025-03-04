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
  };
}
