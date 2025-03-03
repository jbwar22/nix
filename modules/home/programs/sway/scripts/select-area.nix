pkgs:
pkgs.writeShellScript "sway-select-area" ''
  # provide slurp with initial list of window areas for easy window
  # selecting

  swaymsg -t get_tree | \
  jq -r \
      '.. |
       ((.nodes? // empty)+(.floating_nodes? // empty))[] |
       select(.pid and .visible) |
       .rect |
       "\(.x),\(.y) \(.width)x\(.height)"' | \
  ${pkgs.slurp}/bin/slurp
''
