{ config, lib, pkgs, ... }:

with lib; with ns config ./.; {
  options = opt {
    enable = mkEnableOption "bash";
    hostcolor = mkOption {
      type = with types; str;
      description = "ansi color for host in PS1";
      default = "\\033[33m";
    };
    sourcedFiles = mkOption {
      type = with types; listOf (oneOf [str path]);
      description = "list of paths to source";
      default = [];
    };
  };
  config = mkIf cfg.enable {
    custom.home.opts.aliases = {
      ll = "ls -hal";
      # rb = "nixos-rebuild switch --sudo";
      rb = "${pkgs.nh}/bin/nh os switch /etc/nixos";
      # rbb = "nixos-rebuild boot --sudo";
      rbb = "${pkgs.nh}/bin/nh os boot /etc/nixos";
      ng = "sudo nix-collect-garbage --delete-older-than 7d";
    };

    programs.bash = let
      sourcedFiles = pipe cfg.sourcedFiles [
        (map (x: "[[ -f ${x} ]] && source ${x}"))
        concatLines
      ];
    in {
      enable = true;
      enableCompletion = true;
      shellAliases = config.custom.home.opts.aliases;
      bashrcExtra = ''
        if [[ $- == *i* ]]; then # interactive only
          :
          ${sourcedFiles}
        fi
        PS1="\[\033[38;5;166m\]\u\[\033[0m\]@\[${cfg.hostcolor}\]\h\[\033[0m\]:\W \! $ "
      '';
    };

    custom.home.behavior.impermanence.paths = [
      { path = ".bash_history"; file = true; }
    ];
  };
}
