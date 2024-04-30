vim.keymap.set("n", "<C-e>", vim.cmd.NvimTreeToggle)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

local format_code = function()
  local active_clients = vim.lsp.get_active_clients()
  local formatted = false

  for _, client in ipairs(active_clients) do
    if client.server_capabilities.documentFormattingProvider then
      vim.lsp.buf.format({ timeout_ms = 1000 })
      formatted = true
      break
    end
    if not formatted then
      vim.cmd("normal! mzgg=G`zzz")
    end
  end
end

vim.keymap.set("n", "<leader>==", format_code)

-- copy/paste system clipboard
vim.keymap.set({"v", "n"}, "<leader>y", "\"*y", { desc = "Copy to system clipboard", silent = true });
vim.keymap.set({"v", "n"}, "<leader>p", "\"*p", { desc = "Paste from system clipboard", silent = true });





