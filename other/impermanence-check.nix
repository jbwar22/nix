outputs: pkgs: lib: with lib; let
  getMounts = cfg: pipe cfg.config.fileSystems [
    attrsToList
    (filter (x: x.value.fsType == "btrfs"))
    (map (x: pipe x [
      (x: x.value.options)
      (filter (y: hasPrefix "subvol=" y))
      (x: if (length x) > 0 then head x else "")
      (removePrefix "subvol=")
    ]))
    (filter (x: ((hasPrefix "back/root/" x) || (hasPrefix "local/root/" x))))
    (imap0 (i: x: "mounts[${toString i}]=\"${x}\""))
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
    ''))
    concatLines
  ]) + ''
    ${if hasHosts then "else" else ""}
      echo enter a hostname for which impermanence is enabled
      exit 1
    ${if hasHosts then "fi" else ""}
  '';
in pkgs.writeShellScriptBin "impermanence-check" ''
  mapfile -t subvols < <(${pkgs.btrfs-progs}/bin/btrfs subvolume list /persist | ${pkgs.coreutils}/bin/cut -d" " -f9- | ${pkgs.gnugrep}/bin/grep -e "\(local\|back\)/root/")

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
