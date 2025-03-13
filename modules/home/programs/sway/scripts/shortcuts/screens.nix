pkgs: lib: config:

with lib; let
  screens = config.custom.home.opts.screens;

  getScript = output-def: let
    swaymsg-lines = pipe output-def [

    ];
  in pkgs.writeShellScript "shortcuts-screens-specialization" ''
    ${swaymsg-lines}
  '';

  getUndo = specialisation-def: output-def: pipe specialisation-def [
    (mapAttrs (setting-name: setting-value: if typeOf setting-value == "set" then (
      getUndo setting-value output-def.${setting-name}
    ) else (
      output-def.${setting-name}
    )))
  ];

  specialisation-output-settings = pipe screens [
    (filterAttrs (n: output-def: output-def.specialisations != null))
    (mapAttrsToList (output-name: output-def: (mapAttrsToList (specialisation-name: specialisation-def: {
      inherit output-name output-def specialisation-name specialisation-def;  
    }) output-def.specialisations)))
    concatLists
    (foldl' (accum: entry: accum // {
      ${entry.specialisation-name}.${entry.output-name} = entry.specialisation-def;
      ${"!" + entry.specialisation-name}.${entry.output-name} = getUndo entry.specialisation-def entry.output-def;
    }) {})
  ];

  specialization-scripts = pipe specialisation-output-settings [
    (mapAttrs (specialization-name: output-defs: pipe output-defs [
      (mapAttrsToList (output-name: output-def: if hasAttr "sway" output-def then (
        pipe output-def.sway [
          (mapAttrsToList (sway-command-name: sway-command-value: ''
            ${pkgs.sway}/bin/swaymsg 'output "${output-name}" ${sway-command-name} ${sway-command-value}'
          ''))
          (concatStringsSep "\n")
        ]
      ) else ""))
      (concatStringsSep "\n")
      (pkgs.writeShellScript "shortcuts-screens-specialization")
    ]))
  ];
in specialization-scripts // {
  vert_old = pkgs.writeShellScript "shortcuts-screens-vert" ''
    ${pkgs.sway}/bin/swaymsg 'output "ASUSTek COMPUTER INC VG27AQL1A S1LMQS102258" transform 90'
  '';
  reset_old = pkgs.writeShellScript "shortcuts-screens-reset" ''
    ${pkgs.sway}/bin/swaymsg 'output "ASUSTek COMPUTER INC VG27AQL1A S1LMQS102258" transform 0'
  '';
}
