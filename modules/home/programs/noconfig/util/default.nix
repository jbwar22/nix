{ config, lib, pkgs, ... }:

with lib; mkNsEnableModule config ./. {
  home.packages = with pkgs; [
    appimage-run
    cowsay
    dig
    ffmpeg
    file
    gawk
    git
    git-crypt
    jq
    nmap
    ripgrep
    rsync
    snapcast
    sqlite
    sshfs
    tree
    unzip
    wget
    which
    wl-clipboard
    yt-dlp
    zip
  ];

   
  custom.home.opts.aliases = {
    yt-dlp-c = "${pkgs.yt-dlp}/bin/yt-dlp --cookies-from-browser firefox:/home/${config.home.username}/.librewolf/c3juc9f4.default-release";
    rsync-p2 = "rsync --no-i-r --info=progress2";
  };
}
