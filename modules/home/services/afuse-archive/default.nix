{ config, lib, pkgs, ... }:

with lib; mkNsEnableModule config ./. (let
  mounter = pkgs.writeShellScript "afuse-archive-mounter" ''
    r=$1
    m=$2
    dir=$3
    if [[ "$r" == *.zip ]]; then
      ${pkgs.mount-zip}/bin/mount-zip $dir/$r $m
    elif [[ "$r" == *.tar ]] || [[ "$r" == *.tar.gz ]] || [[ "$r" == *.tar.bz2 ]]; then
      ${pkgs.archivemount}/bin/archivemount $dir/$r $m
    else
      exit 1
    fi
  '';
  lister = pkgs.writeShellScript "afuse-archive-lister" ''
    ${pkgs.coreutils}/bin/ls $1 | ${pkgs.gnugrep}/bin/grep -E "(\.zip|\.tar|\.tar\.gz|\.tar\.bz2)\$"
  '';
  afuse-archive = pkgs.writeShellScript "afuse-archive" ''
    dir=$1
    mountpoint=$dir/archivemnt
    ${pkgs.coreutils}/bin/mkdir -p $mountpoint
    ${pkgs.afuse}/bin/afuse \
    -o timeout=300 \
    -o auto_unmount \
    -o mount_template="${mounter} %r %m $dir" \
    -o unmount_template="fusermount -u -z %m" \
    -o populate_root_command="${lister} $dir" \
    $mountpoint
  '';
in {
  systemd.user.enable = mkDefault true;

  systemd.user.services.afuse-archive = {
    Unit = {
      Description="afuse archive";
      Requires = [ "agenix.service" ];
    };
    Service = {
      Type = "forking";
      ExecStart = pkgs.writeShellScript "afuse-archive-all-dirs" ''
        ${pkgs.coreutils}/bin/cat ${ageOrDefault config "afuse-archive-dirs" ""} | \
        while read dir; do
          ${afuse-archive} $dir
        done
      '';
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  home.packages = [ (pkgs.writeShellScriptBin "afuse-archive-here" ''
    ${afuse-archive} $(${pkgs.coreutils}/bin/pwd)
  '') ];
})
