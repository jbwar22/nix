{ lib, ... }:

with lib.nv; {
  plugins.fzf-lua = {
    enable = true;
  };
  
  keymaps = [
    (mkMap "go" "<cmd>lua require('fzf-lua').files()<CR>")
    (mkMapEx "g//" "n" {} "<cmd>lua require('fzf-lua').live_grep_native()<CR>")
    (mkMapEx "g//" "v" {} "<cmd>lua require('fzf-lua').grep_visual()<CR>")
    (mkMap "g/w" "<cmd>lua require('fzf-lua').grep_cword()<CR>")
  ];
}
