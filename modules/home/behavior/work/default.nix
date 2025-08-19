{ config, lib, ... }:

with lib; mkNsEnableModule config ./. {
  custom.home = {
    programs.bash.sourcedFiles = [ "~/work/scripts/workrc" ];
    behavior.impermanence.dirs = [
      "work"
      ".aws"
    ];
  };
}
