{ config, lib, pkgs, ... }:

with lib; mkNsEnableModule config ./. {
  home.packages = with pkgs; [
    appimage-run
    archivemount
    cowsay
    dig
    ffmpeg
    file
    gawk
    git
    git-crypt
    jq
    ncdu
    nmap
    ripgrep
    rsync
    smartmontools
    snapcast
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

    (pkgs.writeShellScriptBin "cdarchive" ''
      mountpoint=$(${pkgs.coreutils}/bin/mktemp -d)
      ${pkgs.archivemount}/bin/archivemount "$1" $mountpoint
      echo "entering archive (ctrl-d to exit)"
      echo 'currend pwd stored in $PREV'
      PREV="$(${pkgs.coreutils}/bin/pwd)"
      pushd $mountpoint > /dev/null
      PREV="$PREV" ${pkgs.bashInteractive}/bin/bash
      popd > /dev/null
      umount $mountpoint
      ${pkgs.coreutils}/bin/rmdir $mountpoint
    '')
  ];

   
  custom.home.opts.aliases = {
    yt-dlp-c = "${pkgs.yt-dlp}/bin/yt-dlp --cookies-from-browser firefox:/home/${config.home.username}/.librewolf/c3juc9f4.default-release";
    rsync-p2 = "rsync --no-i-r --info=progress2";
  };
}
