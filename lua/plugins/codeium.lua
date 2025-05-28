return {
  "Exafunction/codeium.vim",
  event = "InsertEnter",
  config = function()
    vim.g.codeium_enabled = 0
    vim.g.codeium_disable_bindings = 1
    vim.g.codeium_idle_delay = 250

    vim.keymap.set('n', '<leader>ai', ':CodeiumToggle<CR>', { desc = "Toggle Codeium" })

    vim.keymap.set("i", "<C-y>", function() return vim.fn["codeium#Accept"]() end, { expr = true, silent = true })
    vim.keymap.set("i", "<C-n>", function() return vim.fn  end, { expr = true, silent = true })
    vim.keymap.set("i", "<C-x>", function() return vim.fn["codeium#Clear"]() end, { expr = true, silent = true })
  end,
}
