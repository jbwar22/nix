{ config, lib, ... }:

with lib; with ns config ./.; {
  options = opt {
    enable = mkEnableOption "bash";
  };

  config = mkIf cfg.enable {

    custom.home.opts.aliases = {
      ll = "ls -hal";
      rb = "nixos-rebuild switch --use-remote-sudo";
    };

    programs.bash = {
      enable = true;
      enableCompletion = true;
      shellAliases = config.custom.home.opts.aliases;
      bashrcExtra = ''
        PS1="\[\033[38;5;166m\]\u\[\033[0m\]@\[\033[33m\]\h\[\033[0m\]:\W \! $ "
      '';
    };

  };
}
