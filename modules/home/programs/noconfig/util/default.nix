{ config, pkgs, ns, ... }:

let
  inherit (pkgs)
  appimage-run
  archivemount
  bashInteractive
  coreutils
  cowsay
  dig
  ffmpeg
  file
  gawk
  hydra-check
  jq
  ncdu
  nh
  nix-output-monitor
  nmap
  p7zip
  ripgrep
  rsync
  smartmontools
  snapcast
  speedtest-cli
  sqlite
  sshfs
  tree
  unzip
  wget
  which
  wl-clipboard
  wl-mirror
  writeShellScriptBin
  yt-dlp
  zip
  ;
in ns.enable {
  home.packages = [
    appimage-run
    archivemount
    cowsay
    dig
    ffmpeg
    file
    gawk
    hydra-check
    jq
    ncdu
    nh
    nix-output-monitor
    nmap
    p7zip
    ripgrep
    rsync
    smartmontools
    snapcast
    speedtest-cli
    sqlite
    sshfs
    tree
    unzip
    wget
    which
    wl-clipboard
    wl-mirror
    yt-dlp
    zip

    (writeShellScriptBin "cdarchive" ''
      mountpoint=$(${coreutils}/bin/mktemp -d)
      ${archivemount}/bin/archivemount "$1" $mountpoint
      echo "entering archive (ctrl-d to exit)"
      echo 'currend pwd stored in $PREV'
      PREV="$(${coreutils}/bin/pwd)"
      pushd $mountpoint > /dev/null
      PREV="$PREV" ${bashInteractive}/bin/bash
      popd > /dev/null
      umount $mountpoint
      ${coreutils}/bin/rmdir $mountpoint
    '')
  ];

   
  custom.home.opts.aliases = {
    yt-dlp-c = "${yt-dlp}/bin/yt-dlp --cookies-from-browser firefox:/home/${config.home.username}/.librewolf/c3juc9f4.default-release";
    rsync-p2 = "rsync -r --no-i-r --info=progress2";
  };
}
