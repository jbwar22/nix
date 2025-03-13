pkgs: lib: config: let
  params-by-bar = {
    "bar768" = {
    };
    "bar1440" = {
      font-size = 11;
      height = 29;
      padding-top = 3;
    };
    "bar1080" = {
      font-size = 9;
      padding-top = 5;
      height = 26;
    };
  };

  runline = (args:
    "$tofi --output=$output_output " + (builtins.concatStringsSep " " (map (attr:
      "--${attr.name}=${toString attr.value}"
    ) (lib.attrsToList args))
  ));

  if-blocks = with lib; pipe config.custom.home.opts.screens [
    attrsToList
    (map (screen: let
      output_var = if screen.value.noserial then "$output_name_noserial" else "$output_name";
    in ''
      if [[ "${output_var}" == "${screen.name}" ]]; then
        ${runline (params-by-bar."${screen.value.bar}")}
        exit $?
      fi
    ''))
    (concatStringsSep " ")
  ];

in pkgs.writeShellScript "sway-menu" ''
  tofi="${pkgs.tofi}/bin/tofi"
  while getopts ":d" opt; do
    case $opt in
      d)
        tofi="${pkgs.tofi}/bin/tofi-drun"
        ;;
      \?)
        echo "Invalid option: -$OPTARG" >&2
        exit 1
        ;;
    esac
  done

  outputs=$(${pkgs.sway}/bin/swaymsg -t get_outputs)
  output_output=$( \
    echo $outputs | ${pkgs.jq}/bin/jq -r '.[] | select(.focused==true).name' \
  )
  output_name=$( \
    echo $outputs | ${pkgs.jq}/bin/jq -r '.[] | select(.focused==true) | "\(.make) \(.model) \(.serial)"' \
  )
  output_name_noserial=$( \
    echo $outputs | ${pkgs.jq}/bin/jq -r '.[] | select(.focused==true) | "\(.make) \(.model)"' \
  )
  ${if-blocks}
''
