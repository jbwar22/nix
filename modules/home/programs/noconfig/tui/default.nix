{ pkgs, inputs, ns, ... }:

let
  inherit (pkgs)
  btop
  fetchFromGitHub
  glibc
  htop
  pulsemixer
  stdenv;
in ns.enable {
  home.packages = [
    htop
    btop
    pulsemixer
    inputs.home-manager.packages.${stdenv.hostPlatform.system}.default
    inputs.agenix.packages.${stdenv.hostPlatform.system}.default

    (stdenv.mkDerivation rec {
      pname = "shorkfetch";
      version = "0.1.1";
      src = fetchFromGitHub {
        owner = "SharktasticA";
        repo = pname;
        rev = version;
        hash = "sha256-yjLeqwEsrBG0S6BjL0QQBVldIG1zm0pcQ4l7IINKK/I=";
      };
      nativeBuildInputs = [
        glibc.static
      ];
      installPhase = ''
        make install DESTDIR=$out PREFIX=
      '';
    })
  ];
}
