{ inputs, config, lib, ... }:

with lib; mkNsEnableModule config ./. {
  services.easyeffects = {
    enable = true;
    preset = "gracefu";
  };

  xdg.configFile."easyeffects/output/gracefu.json".source = "${inputs.framework-dsp}/config/output/Gracefu's Edits.json";
}
