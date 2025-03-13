pkgs: lib: config: menu:

with lib; rec {
  screens = import ./screens.nix pkgs lib config;
  launcher = let
    options = [ "a" "b" ];
    options-str = concatStringsSep "\n" options;
  in pkgs.writeShellScript "shortcuts-launcher" ''
    case $(echo ${options-str} | ${menu}) in
      \?)
        exit 1
        ;;
    esac
  '';
}
