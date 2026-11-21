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
  getSetting = attrPathStr: let
    attrPath = lib.splitString "." attrPathStr;
    attrAllPath = (lib.init attrPath) ++ [ "default" ];
  in 
    if (lib.hasAttrByPath attrPath manifestSettings)
    then lib.getAttrFromPath attrPath manifestSettings
    else (
      if (lib.hasAttrByPath attrAllPath manifestSettings)
      then lib.getAttrFromPath attrAllPath manifestSettings
      else ""
    );

  manifest = writeText "manifest.toml" ''
    [input]
    theme = "theme_out"
    dir = "@sourceRoot@"

    [files]
    pointer     = "${getSetting "files.pointer"}"
    help        = "${getSetting "files.help"}"
    working     = "${getSetting "files.working"}"
    busy        = "${getSetting "files.busy"}"
    precision   = "${getSetting "files.precision"}"
    text        = "${getSetting "files.text"}"
    hand        = "${getSetting "files.hand"}"
    unavailable = "${getSetting "files.unavailable"}"
    vert        = "${getSetting "files.vert"}"
    horz        = "${getSetting "files.horz"}"
    dgn1        = "${getSetting "files.dgn1"}"
    dgn2        = "${getSetting "files.dgn2"}"
    move        = "${getSetting "files.move"}"
    alternate   = "${getSetting "files.alternate"}"
    link        = "${getSetting "files.link"}"
    person      = "${getSetting "files.person"}"
    pin         = "${getSetting "files.pin"}"

    [sizes]
    pointer     = "${getSetting "sizes.pointer"}"
    help        = "${getSetting "sizes.help"}"
    working     = "${getSetting "sizes.working"}"
    busy        = "${getSetting "sizes.busy"}"
    precision   = "${getSetting "sizes.precision"}"
    text        = "${getSetting "sizes.text"}"
    hand        = "${getSetting "sizes.hand"}"
    unavailable = "${getSetting "sizes.unavailable"}"
    vert        = "${getSetting "sizes.vert"}"
    horz        = "${getSetting "sizes.horz"}"
    dgn1        = "${getSetting "sizes.dgn1"}"
    dgn2        = "${getSetting "sizes.dgn2"}"
    move        = "${getSetting "sizes.move"}"
    alternate   = "${getSetting "sizes.alternate"}"
    link        = "${getSetting "sizes.link"}"
    person      = "${getSetting "sizes.person"}"
    pin         = "${getSetting "sizes.pin"}"
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
    ani2xcursor --resample nearest .
  '';
  installPhase = ''
    install -dm 0755 $out/share/icons/${name}
    cp -r out/theme_out/xcursor/* $out/share/icons/${name}
  '';
}
