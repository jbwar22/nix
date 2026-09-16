{ pkgs, inputs, ns, ... }:

let
  inherit (pkgs) stdenv;
  inherit (stdenv.hostPlatform) system;

  shorkfetch = stdenv.mkDerivation rec {
    pname = "shorkfetch";
    version = "0.1.1";
    src = pkgs.fetchFromGitHub {
      owner = "SharktasticA";
      repo = pname;
      rev = version;
      hash = "sha256-yjLeqwEsrBG0S6BjL0QQBVldIG1zm0pcQ4l7IINKK/I=";
    };
    nativeBuildInputs = [
      pkgs.glibc.static
    ];
    installPhase = ''
      make install DESTDIR=$out PREFIX=
    '';
  };
in ns.enable {
  home.packages = builtins.attrValues {
    inherit (pkgs)
    btop
    htop
    pulsemixer;

    inherit (inputs.home-manager.packages.${system})
    home-manager;

    inherit (inputs.agenix.packages.${system})
    agenix;

    inherit
    shorkfetch;
  };
}
