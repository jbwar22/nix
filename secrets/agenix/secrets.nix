let
  users = rec {
    jackson= {
      monstro-keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCirJ2siQwyzwawQlL5VSdXdgNUI9As4OzTB99rPWYDZgGrZVWelk57Ekf+8wXJo8tBm5x+LM/2Qjs2krvvdWvqyoytl0bY78OsFb7VgOo1oRuMPnLFrQCKl9tPfzBTd6AMJB7cbe1ioxRvDOSn95PK308oWezW7YGJU8jHNu75leEDiF5PSkF21mGTT0q7coj/N6fdc461MIIJUh/hPxjeh1o6YKZuTcFSuAq0k1r9FrREaye5+tio33hhsgJFwJ/AygeYLnTFdWhPu3UArkyqAKV6y+rQo/rkO7f73FZlg8Pd/3w8GX7e1dQxamH1japdSpSzRcgzazY+/80NlEIM5jQvmNy2HW+S+WwDgkCCLhHXiCi1GOUcRbeQZBVG+gpF0VJ+ISU1Rfr6JNtdkKO/OJXSfav5grIDM3gtc7nvstXrrCNkT+fi8+LTgx/lPCpi9rYYeWCHxOdS/XEPEs/IO3P6wkeS8AOmkORYEOdOC8r3ZssWBYhWzjxeZAfeBjM=" ];
      widow-keys = [];
    };
    all-jackson-keys = jackson.monstro-keys ++ jackson.widow-keys;
  };
  all-user-keys = users.all-jackson-keys;

  hosts = {
    monstro-keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO9z0yK5MUPo2cxKF1C7HISLPWPSuMBuYsLfC70Czg2o" ];
    widow-keys = [];
  };
  all-host-keys = hosts.monstro-key ++ hosts.widow-key;
in {
  "monstro-jackson-geolocation.age".publicKeys = users.jackson.monstro-keys;
  "widow-jackson-geolocation.age".publicKeys = users.jackson.widow-keys;
}
