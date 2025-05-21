{ pkgs, ... }:

{
  config.extraPlugins = [

    (pkgs.vimUtils.buildVimPlugin {
      name = "vim-moonfly-colors";
      version = "test";
      src = pkgs.fetchFromGitHub {
        owner = "bluz71";
        repo = "vim-moonfly-colors";
        rev = "39b2432";
        hash = "sha256-MqwGW7PNNeki/EH2w83qhAWG8m+RS4zcoj0YJq3Vof0=";
      };
    })

    (pkgs.vimUtils.buildVimPlugin {
      name = "vim-indentwise";
      version = "test";
      src = pkgs.fetchFromGitHub {
        owner = "jeetsukumaran";
        repo = "vim-indentwise";
        rev = "v1.0.0";
        hash = "sha256-lCCvn8IXDSX39caq0ONi5F22v9W/LZx4TFC/8Sg4eMc=";
      };
    })

  ];
}
