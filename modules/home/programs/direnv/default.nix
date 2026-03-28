{ ns, ... }:

ns.enable {
  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
    config = {
      hide_env_diff = true;
    };
  };

  custom.home.behavior.impermanence.paths = [ ".local/share/direnv" ];
}
