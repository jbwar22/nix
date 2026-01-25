{ config, lib, pkgs, ... }:

with lib; mkNsEnableModule config ./. (let
  hf = config.custom.home.opts.hostfeatures;
in {
  home.packages = warnIf (!(hf.hasSerialSupport)) "\"dialout\" group needed for arduino packages" (with pkgs; [
    arduino-cli
    arduino-ide
  ]);

  custom.home.behavior.impermanence.paths = [
    ".arduino15"
    # ".arduinoIDE"
  ];
})
