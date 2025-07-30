pkgs: lib: menu:

pkgs.writeShellScript "shortcuts-runner" ''
  package=$(echo | ${menu} -r -p "nix run nixpkgs#")
  nix run nixpkgs#''${package}
''
