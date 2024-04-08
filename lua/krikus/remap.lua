vim.keymap.set("n", "<C-e>", vim.cmd.NvimTreeToggle)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")

vim.keymap.set("x", "<leader>p", [["_dP]])

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

vim.keymap.set("n", "<leader>==", "mzgg=G`zzz")

-- copy/paste system clipboard
vim.keymap.set("v", "<leader>y", "\"+y");
vim.keymap.set({"v", "n"}, "<leader>p", "\"+p");
