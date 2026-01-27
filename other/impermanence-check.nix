cname: outputs: pkgs: lib: with lib; let
  mounts = pipe outputs.nixosConfigurations.${cname}.config.fileSystems [
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
