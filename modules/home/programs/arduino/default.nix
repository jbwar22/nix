{ config, lib, pkgs, ... }:

with lib; mkNsEnableModule config ./. (let
  hf = config.custom.home.opts.hostfeatures;
in {
  home.packages = warnIf (!(hf.hasSerialSupport)) "\"dialout\" group needed for arduino packages" (with pkgs; [
    arduino-cli
    arduino-ide
  ]);

  home.persistence = persistUserDirs config [
    ".arduino15"
    # ".arduinoIDE"
  ];
})
