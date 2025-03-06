{ lib, ... }:

with lib.nv; with lib; {
  
  imports = getDirs ./.;

  config = {
    colorscheme = "moonfly";

    globals = {

    };

    opts = {
      autoread = true;
      breakindent = true;
      clipboard = "unnamed";
      colorcolumn = "81,101,121";
      cursorline = true;
      fixeol = false;
      ignorecase = true;
      mouse = "a";
      number = true;
      relativenumber = false;
      scrolloff = 5;
      signcolumn="yes";
      smartcase = true;
      title = true;
      wildmenu = true;
      wrap = true;

      # indentation
      autoindent = true;
      tabstop = 4;
      shiftwidth = 4;
      softtabstop = 4;
      expandtab = true;

      # undofile = true;
      # undopath = ???
    };

    keymaps = [
      (mkMap "<leader>a" ":AerialToggle float<CR>")
      (mkMap "<leader>A" ":AerialToggle<CR>")
      (mkMap "<leader>n" ":set nonumber!<CR>")      # toggle number
      (mkMap "gb" ":ls<CR>:b<space>")               # list and show buffers
      (mkMap "n" "nzzzv")
      (mkMap "N" "Nzzzv")
    ];

    autoCmd = [
      { event = "FileType";
        pattern = [ "elm" "yaml" "nix" "html" "htmldjango" "vue" "javascript" ];
        command = "setlocal sw=2 ts=2 sts=2";
      }
    ];

    userCommands = {
      # Q.command = ":mksession ~/tmp/primary-nvim.vimsession<CR>:q";
    };

  };
}
