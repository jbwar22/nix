let
  keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCirJ2siQwyzwawQlL5VSdXdgNUI9As4OzTB99rPWYDZgGrZVWelk57Ekf+8wXJo8tBm5x+LM/2Qjs2krvvdWvqyoytl0bY78OsFb7VgOo1oRuMPnLFrQCKl9tPfzBTd6AMJB7cbe1ioxRvDOSn95PK308oWezW7YGJU8jHNu75leEDiF5PSkF21mGTT0q7coj/N6fdc461MIIJUh/hPxjeh1o6YKZuTcFSuAq0k1r9FrREaye5+tio33hhsgJFwJ/AygeYLnTFdWhPu3UArkyqAKV6y+rQo/rkO7f73FZlg8Pd/3w8GX7e1dQxamH1japdSpSzRcgzazY+/80NlEIM5jQvmNy2HW+S+WwDgkCCLhHXiCi1GOUcRbeQZBVG+gpF0VJ+ISU1Rfr6JNtdkKO/OJXSfav5grIDM3gtc7nvstXrrCNkT+fi8+LTgx/lPCpi9rYYeWCHxOdS/XEPEs/IO3P6wkeS8AOmkORYEOdOC8r3ZssWBYhWzjxeZAfeBjM=" ];
in {
  "geolocation.age".publicKeys = keys;
  "shairport-password.age".publicKeys = keys;

  "rclone-ay5efs34-args.age".publicKeys = keys;
  "rclone-ay5efs34-conf.age".publicKeys = keys;
}
