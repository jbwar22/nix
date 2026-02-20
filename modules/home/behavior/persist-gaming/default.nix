{ config, lib, ... }:

with lib; mkNsEnableModule config ./. {
  custom.home.behavior.impermanence.paths = [
    # very minor stuff, some kind of language setting
    { path = ".steam"; origin = "local"; }

    # only back up prefixes with game save data
    { path = ".local/share/Steam"; origin = "local"; }
    ".local/share/Steam/steamapps/compatdata"

    ".config/unity3d"
  ];
}
