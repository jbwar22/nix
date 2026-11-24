pkgs:

pkgs.writeShellScript "shortcuts-sigkill" ''
  ${pkgs.sway}/bin/swaymsg -t get_tree \
  | ${pkgs.jq}/bin/jq '.. | select(.type?) | select(.focused==true) | .pid' \
  | ${pkgs.findutils}/bin/xargs -r ${pkgs.util-linux}/bin/kill -9
''
