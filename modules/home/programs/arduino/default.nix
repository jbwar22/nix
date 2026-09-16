{ config, lib, pkgs, ns, ... }:

ns.enable (let
  hf = config.custom.home.opts.hostfeatures;
in {
  home.packages = lib.warnIf (!(hf.hasSerialSupport)) "\"dialout\" group needed for arduino packages" ([
    pkgs.arduino-cli
    pkgs.arduino-ide
  ]);

  custom.home.behavior.impermanence.paths = [
    ".arduino15"
    # ".arduinoIDE"
  ];
})
