vim.keymap.set("n", "<C-e>", vim.cmd.NvimTreeToggle)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")

vim.keymap.set("n", "<leader>rg", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

vim.keymap.set("n", "<C-w>=", "[[<C-w>20>]]")

local format_code = function()
  local active_clients = vim.lsp.get_active_clients()
  local formatted = false

  for _, client in ipairs(active_clients) do
    if client.server_capabilities.documentFormattingProvider then
      vim.lsp.buf.format({ timeout_ms = 1000 })
      formatted = true
    end
    -- check if eslint can be used to fix the code
    if client.name == "eslint" then
      vim.lsp.buf.format({ timeout_ms = 1000 })
      formatted = true
      break
    end
  end
  if not formatted then
    vim.cmd("normal! mzgg=G`zzz")
  end
end

vim.keymap.set("n", "<leader>==", format_code)

-- copy/paste system clipboard
vim.keymap.set({"v", "n"}, "<leader>y", "\"+y", { desc = "Copy to system clipboard", silent = true });
vim.keymap.set({"v", "n"}, "<leader>p", "\"+p", { desc = "Paste from system clipboard", silent = true });


-- next prev error
vim.keymap.set("n", "[e", function() vim.diagnostic.goto_prev({ severity = "ERROR", wrap = true }) end, { desc = "Go to prev error" })
vim.keymap.set("n", "]e", function() vim.diagnostic.goto_prev({ severity = "ERROR", wrap = true }) end, { desc = "Go to next error" })


