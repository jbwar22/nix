{ pkgs, ... }:

{
  plugins.treesitter = {
    enable = true;

    grammarPackages = [
      pkgs.vimPlugins.nvim-treesitter.builtGrammars.jsonnet
    ];

    settings = {
      highlight.enable = true;
    };
  };
}
