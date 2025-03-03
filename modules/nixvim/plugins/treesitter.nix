{ pkgs, ... }:

{
  plugins.treesitter = {
    enable = true;

    grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
      jsonnet
    ];

    settings = {
      highlight.enable = true;
    };
  };
}
