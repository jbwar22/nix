{ lib, ... }:

with lib.nv; {
  plugins.aerial = {
    enable = true;
    settings = {
      attach_mode = "global";
    };
  };
  
  keymaps = [
    (mkMap "<leader>a" ":AerialToggle float<CR>")
    (mkMap "<leader>A" ":AerialToggle<CR>")
  ];
}
