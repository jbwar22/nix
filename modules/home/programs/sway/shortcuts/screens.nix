pkgs: lib: config:

let
  inherit (lib)
  concatLists
  concatStringsSep
  filterAttrs
  foldl'
  hasAttr
  mapAttrs
  mapAttrsToList
  mkIf
  pipe
  recursiveUpdate
  typeOf;
  inherit (pkgs)
  procps
  sway
  writeShellScript;

  screens = config.custom.home.opts.screens;

  getUndo = specialisation-def: output-def: pipe specialisation-def [
    (mapAttrs (setting-name: setting-value: if typeOf setting-value == "set" then (
      getUndo setting-value output-def.${setting-name}
    ) else (
      output-def.${setting-name}
    )))
  ];

  getSwaymsgLines = output-name: output-def: if hasAttr "sway" output-def then (
    pipe output-def.sway [
      (mapAttrsToList (sway-command-name: sway-command-value: ''
        ${sway}/bin/swaymsg 'output "${output-name}" ${sway-command-name} ${sway-command-value}'
      ''))
      (concatStringsSep "\n")
    ]
  ) else "";

  specialisation-scripts = pipe screens [
    (filterAttrs (n: output-def: output-def.specialisations != null))
    (mapAttrsToList (output-name: output-def: (mapAttrsToList (specialisation-name: specialisation-def: {
      inherit output-name output-def specialisation-name specialisation-def;  
    }) output-def.specialisations)))
    concatLists
    (foldl' (accum: entry: recursiveUpdate accum {
      ${entry.specialisation-name}.${entry.output-name} = entry.specialisation-def;
      ${"!" + entry.specialisation-name}.${entry.output-name} = getUndo entry.specialisation-def entry.output-def;
    }) {
      reset = screens;
    })
    (mapAttrs (specialisation-name: output-defs: pipe output-defs [
      (mapAttrsToList (output-name: output-def: concatStringsSep "\n" [
        (getSwaymsgLines output-name output-def)
      ]))
      (concatStringsSep "\n")
      (writeShellScript "shortcuts-screens-specialisation-${specialisation-name}")
    ]))
  ];
in specialisation-scripts // {
  gammatoggle = mkIf config.custom.home.programs.sway.blueLightFilter (writeShellScript "reset-gammastep" ''
    ${procps}/bin/pkill -USR1 gammastep
  '');
}
