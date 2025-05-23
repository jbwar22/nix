{ config, lib, ... }:

with lib; with ns config ./.; {
  options = opt {
    enable = mkEnableOption "bash";
    hostcolor = mkOption {
      type = with types; str;
      description = "ansi color for host in PS1";
      default = "\\033[33m";
    };
  };
  config = mkIf cfg.enable {
    custom.home.opts.aliases = {
      ll = "ls -hal";
      rb = "nixos-rebuild switch --use-remote-sudo";
      rbb = "nixos-rebuild boot --use-remote-sudo";
    };

    programs.bash = {
      enable = true;
      enableCompletion = true;
      shellAliases = config.custom.home.opts.aliases;
      bashrcExtra = ''
        PS1="\[\033[38;5;166m\]\u\[\033[0m\]@\[${cfg.hostcolor}\]\h\[\033[0m\]:\W \! $ "
      '';
    };

    custom.home.behavior.impermanence.files = [ ".bash_history" ];
  };
}
