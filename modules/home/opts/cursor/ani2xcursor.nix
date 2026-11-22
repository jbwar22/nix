{
  stdenv,
  writeText,
  requireFile,
  unzip,
  lib,

  ani2xcursor,
  name,
  filename,
  url,
  message,
  sha256,
  version ? "1.0.0",
  manifestSettings ? {}
}: let
  getSetting = attrName1: attrName2: default: let
    attrPath = [ attrName1 attrName2 ];
    attrDefaultPath = [ attrName1 "default" ];
  in 
    if (lib.hasAttrByPath attrPath manifestSettings)
    then lib.getAttrFromPath attrPath manifestSettings
    else (
      if (lib.hasAttrByPath attrDefaultPath manifestSettings)
      then lib.getAttrFromPath attrDefaultPath manifestSettings
      else default
    );
  getFile = attrName: getSetting "files" attrName "";
  getSize = attrName: getSetting "sizes" attrName "16,24,32,48,64,96,128";

  manifest = writeText "manifest.toml" ''
    [input]
    theme = "theme_out"
    dir = "@sourceRoot@"

    [files]
    pointer     = "${getFile "pointer"}"
    help        = "${getFile "help"}"
    working     = "${getFile "working"}"
    busy        = "${getFile "busy"}"
    precision   = "${getFile "precision"}"
    text        = "${getFile "text"}"
    hand        = "${getFile "hand"}"
    unavailable = "${getFile "unavailable"}"
    vert        = "${getFile "vert"}"
    horz        = "${getFile "horz"}"
    dgn1        = "${getFile "dgn1"}"
    dgn2        = "${getFile "dgn2"}"
    move        = "${getFile "move"}"
    alternate   = "${getFile "alternate"}"
    link        = "${getFile "link"}"
    person      = "${getFile "person"}"
    pin         = "${getFile "pin"}"

    [sizes]
    pointer     = "${getSize "pointer"}"
    help        = "${getSize "help"}"
    working     = "${getSize "working"}"
    busy        = "${getSize "busy"}"
    precision   = "${getSize "precision"}"
    text        = "${getSize "text"}"
    hand        = "${getSize "hand"}"
    unavailable = "${getSize "unavailable"}"
    vert        = "${getSize "vert"}"
    horz        = "${getSize "horz"}"
    dgn1        = "${getSize "dgn1"}"
    dgn2        = "${getSize "dgn2"}"
    move        = "${getSize "move"}"
    alternate   = "${getSize "alternate"}"
    link        = "${getSize "link"}"
    person      = "${getSize "person"}"
    pin         = "${getSize "pin"}"
  '';
in stdenv.mkDerivation {
  pname = name;
  inherit version;
  src = requireFile {
    name = filename;
    inherit sha256 url message;
  };
  sourceRoot = ".";
  nativeBuildInputs = [
    unzip
    ani2xcursor
  ];
  postUnpack = ''
    mkdir $sourceRoot/ani2xcursor
    cp ${manifest} $sourceRoot/ani2xcursor/manifest.toml
  '';
  postPatch = ''
    substituteInPlace $sourceRoot/ani2xcursor/manifest.toml \
      --replace-fail "@sourceRoot@" "$sourceRoot"
  '';
  buildPhase = ''
    ani2xcursor --resample auto --size ${getSize "default"} .
  '';
  installPhase = ''
    install -dm 0755 $out/share/icons/${name}
    cp -r out/theme_out/xcursor/* $out/share/icons/${name}
  '';
}
