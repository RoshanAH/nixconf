{ ... } : {
  programs.nixvim = {
    globals.mapleader = " ";
    keymaps = [
      { action = "<cmd>Ex<CR>"; key = "<leader>e"; mode = "n"; } # netrw
      { action = ":m '>+1<CR>gv=gv"; key = "J"; mode = "v"; } # move lines
      {  action = ":m '>-2<CR>gv=gv"; key = "K"; mode = "v"; }
      { action = "<gv"; key = "<"; mode = "v"; } # indenting change
      { action = ">gv"; key = ">"; mode = "v"; }
      { action = "mzJ`z"; key = "J"; mode = "n"; } # append next line
      { action = "<C-d>zz"; key = "<C-d>"; mode = "n"; } # center screen and carot
      { action = "<C-u>zz"; key = "<C-u>"; mode = "n"; }
      { action = "nzzzv"; key = "n"; mode = "n"; } # center screen when search
      { action = "Nzzzv"; key = "N"; mode = "n"; }
      { action = "\"_dP"; key = "<leader>p"; mode = "x"; } # paste without messing up register
      { action = "\"+y"; key = "<leader>y"; mode = [ "n" "v" ]; } # copy to clipboard
      { action = "\"+Y"; key = "<leader>Y"; mode = "n"; }
      { action = "\"_d"; key = "<leader>d"; mode = [ "n" "v" ]; } # delete without messing up register
      { action = "<nop>"; key = "Q"; mode = "n"; } # nobody likes this
      { action = ":%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>"; key = "<leader>s"; mode = "n"; } # sub word
      { action = "<cmd>!chmod +x %<CR>"; key = "<leader>x"; mode = "n"; options.silent = true; } # make executable
      { action = "<C-w>h"; key = "<leader>h"; mode = "n"; } # changing panes
      { action = "<C-w>j"; key = "<leader>j"; mode = "n"; }
      { action = "<C-w>k"; key = "<leader>k"; mode = "n"; }
      { action = "<C-w>l"; key = "<leader>l"; mode = "n"; }

      # telescope 
      {
        action = "<cmd>Telescope live_grep<CR>";
        key = "<leader>fw";
      }
      {
        action = "<cmd>Telescope find_files<CR>";
        key = "<leader>ff";
      }
      {
        action = "<cmd>Telescope git_commits<CR>";
        key = "<leader>fg";
      }
      {
        action = "<cmd>Telescope oldfiles<CR>";
        key = "<leader>fh";
      }
      {
        action = "<cmd>Telescope colorscheme<CR>";
        key = "<leader>ch";
      }
      {
        action = "<cmd>Telescope man_pages<CR>";
        key = "<leader>fm";
      }


      # undotree
      {
        action = "<cmd>UndotreeToggle<CR>";
        key = "<leader>u";
      }

      # fugitive
      {
        action = "<cmd>lua vim.cmd.Git()<CR>";
        key = "<leader>gs";
        mode = "n";
      }

    ];
  };
}
