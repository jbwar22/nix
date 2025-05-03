{
  stdenvNoCC,
  colorscheme ? {
    background = "#000000";
    border = "#404040";
    text = "#e0e0e0";
    highlight = "#606060";
    separator = "#c0c0c0";
  }
}:

stdenvNoCC.mkDerivation {
  pname = "fcitx5-jbwar22-system-theme";
  version = "1.0.0";
  src = ./assets;
  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/fcitx5/themes/system
    cp * $out/share/fcitx5/themes/system
    substituteInPlace $out/share/fcitx5/themes/system/theme.conf \
      --replace-fail "{{background}}" "${colorscheme.background}" \
      --replace-fail "{{border}}" "${colorscheme.border}" \
      --replace-fail "{{text}}" "${colorscheme.text}" \
      --replace-fail "{{highlight}}" "${colorscheme.highlight}" \
      --replace-fail "{{separator}}" "${colorscheme.separator}"
    runHook postInstall
  '';
}
