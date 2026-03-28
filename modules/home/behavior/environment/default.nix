{ config, lib, ns, ... }:

with lib; ns.enable {
  home.sessionVariables = {
    EDITOR = "vim";
  };
}
