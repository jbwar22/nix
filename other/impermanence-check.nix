outputs: pkgs: lib: with lib; let
  subvolPrefixes = cfg: pipe cfg.config.custom.nixos.behavior.impermanence.devices [
    (map (device: map (origin: let
      subvolRoot = if device.subvol == "/" then "" else "${device.subvol}/";
    in "${subvolRoot}${origin.path}") device.origins))
    flatten
  ];
  getMounts = cfg: pipe cfg.config.fileSystems [
    attrsToList
    (filter (x: x.value.fsType == "btrfs"))
    (map (x: pipe x [
      (x: x.value.options)
      (filter (y: hasPrefix "subvol=" y))
      (x: if (length x) > 0 then head x else "")
      (removePrefix "subvol=")
    ]))
    (filter (x: any (y: hasPrefix y x) (subvolPrefixes cfg)))
    (imap0 (i: x: "mounts[${toString i}]=\"${x}\""))
    concatLines
  ];
  getSubvolAppends = cfg: pipe cfg [
    subvolPrefixes
    (map (x: ''
      mapfile -t subvolstmp < <(${pkgs.coreutils}/bin/printf '%s\n' "''${subvolsraw[@]}" | ${pkgs.gawk}/bin/awk -v s="${x}" 'index($0, s) == 1')
      subvols+=("''${subvolstmp[@]}")
    ''))
    concatLines
  ];
  impermanenceHosts = pipe outputs.nixosConfigurations [
    attrsToList
    (filter (x: x.value.config.custom.nixos.behavior.impermanence.enable))
  ];
  hasHosts = (length impermanenceHosts) != 0;
  mounts = (pipe impermanenceHosts [
    (imap0 (i: x: ''
      ${if i == 0 then "" else "el"}if [[ "$1" == "${x.name}" ]]; then
        ${getMounts x.value}
        ${getSubvolAppends x.value}
    ''))
    concatLines
  ]) + ''
    ${if hasHosts then "else" else ""}
      echo enter a hostname for which impermanence is enabled
      exit 1
    ${if hasHosts then "fi" else ""}
  '';
in pkgs.writeShellScriptBin "impermanence-check" ''
  mapfile -t subvolsraw < <(${pkgs.btrfs-progs}/bin/btrfs subvolume list /persist | ${pkgs.coreutils}/bin/cut -d" " -f9-)
  subvols=()

  ${mounts}

  echo no matching subvol:
  ${pkgs.coreutils}/bin/comm -13 \
    <(${pkgs.coreutils}/bin/printf '%s\n' "''${subvols[@]}" | ${pkgs.coreutils}/bin/sort) \
    <(${pkgs.coreutils}/bin/printf '%s\n' "''${mounts[@]}" | ${pkgs.coreutils}/bin/sort)

  echo
  echo unused btrfs subvols:
  ${pkgs.coreutils}/bin/comm -23 \
    <(${pkgs.coreutils}/bin/printf '%s\n' "''${subvols[@]}" | ${pkgs.coreutils}/bin/sort) \
    <(${pkgs.coreutils}/bin/printf '%s\n' "''${mounts[@]}" | ${pkgs.coreutils}/bin/sort)
''
