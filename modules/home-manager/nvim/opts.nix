{ config, ... } : {

  programs.nixvim = {
    opts = {
      nu = true;
      relativenumber = true;
      mouse = "";

      tabstop = 4;
      softtabstop = 4;
      shiftwidth = 4;
      expandtab = true;

      smartindent = true;

      wrap = false;

      swapfile = false;
      backup = false;
      undodir = "${config.home.homeDirectory}/.vim/";
      undofile = true;

      hlsearch = false;
      incsearch = true;

      termguicolors = true;

      scrolloff = 8;
      signcolumn = "yes";

      updatetime = 50;
    };
  };
}
