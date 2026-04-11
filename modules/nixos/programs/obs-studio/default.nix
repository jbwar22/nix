{ ns, ... }:

ns.enable {
  programs.obs-studio = {
    enable = true;
    enableVirtualCamera = true;
  };
}
