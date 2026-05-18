{ pkgs, inputs, ns, ... }:

ns.enable {
  home.packages = with pkgs; [
    htop
    btop
    pulsemixer
    inputs.home-manager.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default

    (pkgs.stdenv.mkDerivation rec {
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
    })
  ];
}
