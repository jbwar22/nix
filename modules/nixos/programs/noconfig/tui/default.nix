{ pkgs, ns, ... }:

ns.enable {
  environment.systemPackages = with pkgs; [
    vim
  ];
}
