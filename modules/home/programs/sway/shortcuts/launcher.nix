pkgs: lib: config: menu:

with lib; let
  shortcuts = config.custom.home.programs.sway.shortcuts;
  isPackage = check: hasAttr "stdenv" check;
  mkCase = shortcuts: ''
    case $(echo "${concatStringsSep "\n" (attrNames shortcuts)}" | ${menu} -p "run shortcut: ") in
      ${pipe shortcuts [
        attrNames
        (map (shortcut: ''
          "${shortcut}")
            ${let
              innerShortcut = shortcuts.${shortcut};
            in (if (isPackage innerShortcut) then (
              toString innerShortcut
            ) else (
              mkCase innerShortcut
            ))}
            ;;
        ''))
        (concatStringsSep "\n")
      ]}
      \?)
        exit 1
        ;;
    esac
  '';
in pkgs.writeShellScript "shortcuts-launcher" ''
  ${mkCase shortcuts}
''
