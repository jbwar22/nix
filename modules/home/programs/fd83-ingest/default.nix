{ config, lib, pkgs, ... }:

with lib; mkNsEnableModule config ./. (let
  FD83-set-metadata = pkgs.writeShellScriptBin "FD83-set-metadata" ''
    file=$1
    outdir=$2
    filenamefull=$(${pkgs.coreutils}/bin/basename -- "$file")
    extension="''${filenamefull##*.}"
    outfile="''${outdir}/''${filenamefull}"

    modifyDate=$(${pkgs.exiftool}/bin/exiftool -FileModifyDate "$file" | ${pkgs.gawk}/bin/awk -F':' '{print $2"-"$3"-"$4":"$5":"$6":"$7}')
    # file is stored in utc in local time, then linux adjusts into local timezone
    # therefore convert to utc (to get local time) and separately read the timezone
    utc=$(${pkgs.coreutils}/bin/date -d "$modifyDate" -u "+%Y:%m:%d %H:%M:%S")
    tz=$(${pkgs.coreutils}/bin/date -d "$modifyDate" "+%z")

    camera=(-Make="Sony" -Model="Mavica FD83")
    if [[ "$extension" == "MPG" ]]; then
        # write metadata to xmp sidecar
        outfilexmp="''${outfile}.xmp"
        ${pkgs.exiftool}/bin/exiftool "''${camera[@]}" -DateTimeOriginal="$utc$tz" "$outfilexmp" 
        ${pkgs.coreutils}/bin/cp "$file" "$outdir"
    else
        ${pkgs.exiftool}/bin/exiftool "''${camera[@]}" -SubSecDateTimeOriginal="$utc$tz" "$file" -o "$outfile"
    fi
  '';
  FD83-ingest = pkgs.writeShellScriptBin "FD83-ingest" ''
    echo mounting floppy...
    mountpoint=$(${pkgs.udisks}/bin/udisksctl mount -b "/dev/disk/by-id/usb-TEACV0.0_TEACV0.0" | ${pkgs.gawk}/bin/awk -F' ' '{print $4}')
    dumpdir=$(${pkgs.coreutils}/bin/mktemp -d)
    pushd "$mountpoint" &> /dev/null || exit
    echo adding metadata...
    ${pkgs.findutils}/bin/find . -maxdepth 1 -mindepth 1 \( -iname "*.JPG" -o -iname "*.MPG" \) -exec ${getExe FD83-set-metadata} "{}" "$dumpdir" \;
    popd &> /dev/null || exit
    pushd "$dumpdir" &> /dev/null || exit
    echo "fix portrait files"
    echo "also ensure immich is logged in"
    echo "^D when done"
    ${pkgs.bash}/bin/bash
    echo uploading to immich...
    ${pkgs.findutils}/bin/find . -maxdepth 1 -mindepth 1 \( -iname "*.JPG" -o -iname "*.MPG" \) -print0 | ${pkgs.findutils}/bin/xargs -0 ${pkgs.immich-cli}/bin/immich upload
    popd &> /dev/null || exit
    echo cleaning up...
    rm -r "$dumpdir"
    umount "/dev/disk/by-id/usb-TEACV0.0_TEACV0.0"
  '';
  FD83-portrait = pkgs.writeShellScriptBin "FD83-portrait" ''
    file=$1
    ${pkgs.exiftool}/bin/exiftool -Orientation=8 -n $file -overwrite_original
  '';
in {
  home.packages = with pkgs; [
    exiftool
    immich-cli
    FD83-set-metadata
    FD83-ingest
    FD83-portrait
  ];
})
