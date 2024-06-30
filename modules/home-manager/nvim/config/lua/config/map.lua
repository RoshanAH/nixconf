local keymap = vim.keymap.set

vim.g.mapleader = " "
keymap("n", "<leader>e", vim.cmd.Ex)

keymap("v", "J", ":m '>+1<CR>gv=gv")
keymap("v", "K", ":m '<-2<CR>gv=gv")
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

keymap("n", "J", "mzJ`z")
keymap("n", "<C-d>", "<C-d>zz")
keymap("n", "<C-u>", "<C-u>zz")
keymap("n", "n", "nzzzv")
keymap("n", "N", "Nzzzv")

-- greatest remap ever
keymap("x", "<leader>p", [["_dP]])

-- next greatest remap ever : asbjornHaland
keymap({"n", "v"}, "<leader>y", [["+y]])
keymap("n", "<leader>Y", [["+Y]])

keymap({"n", "v"}, "<leader>d", [["_d]])

keymap("n", "Q", "<nop>")

keymap("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
keymap("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- window nav
keymap("n", "<leader>h", "<C-w>h");
keymap("n", "<leader>j", "<C-w>j");
keymap("n", "<leader>k", "<C-w>k");
keymap("n", "<leader>l", "<C-w>l");
