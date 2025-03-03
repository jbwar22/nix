{
  rustPlatform,
  fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "clonck";
  version = "0.0.3";

  src = fetchFromGitHub {
    owner = "jbwar22";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-2eRCTboEBsi+vEtL/sAesL8ehT4SOk0HC2yhltbb4rM=";
  };

  cargoHash = "sha256-/FRs9B0O5tjZQdmu9H+Kt5zAGBITMC2dpwL/p3nfBvw=";
}
