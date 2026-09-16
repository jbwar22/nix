pkgs: lib: config: let
  inherit (lib)
  attrsToList
  concatStringsSep
  pipe;
  inherit (pkgs)
  jq
  sway
  tofi
  writeShellScript;

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
    "bar1920_2x" = {
      font-size = 9;
      padding-top = 2;
      padding-left = 9;
      height = 22;
    };
  };

  runline = (args:
    "$tofi \"\${args[@]}\" --output=$output_output " + (builtins.concatStringsSep " " (map (attr:
      "--${attr.name}=${toString attr.value}"
    ) (lib.attrsToList args))
  ));

  if-blocks = pipe config.custom.home.opts.screens [
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

in writeShellScript "sway-menu" ''
  tofi="${tofi}/bin/tofi"
  args=()
  while getopts ":drp:" opt; do
    case $opt in
      d)
        tofi="${tofi}/bin/tofi-drun"
        ;;
      r)
        tofi="${tofi}/bin/tofi --require-match=false"
        ;;
      p)
        args=(--prompt-text="''${OPTARG}")
        ;;
      \?)
        echo "Invalid option: -$OPTARG" >&2
        exit 1
        ;;
    esac
  done

  outputs=$(${sway}/bin/swaymsg -t get_outputs)
  output_output=$( \
    echo $outputs | ${jq}/bin/jq -r '.[] | select(.focused==true).name' \
  )
  output_name=$( \
    echo $outputs | ${jq}/bin/jq -r '.[] | select(.focused==true) | "\(.make) \(.model) \(.serial)"' \
  )
  output_name_noserial=$( \
    echo $outputs | ${jq}/bin/jq -r '.[] | select(.focused==true) | "\(.make) \(.model)"' \
  )
  ${if-blocks}
''
