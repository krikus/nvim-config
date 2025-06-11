return {
  "f-person/git-blame.nvim",
  config = function()
    require('gitblame').setup({
      enabled = false,
      -- schedule_event = 'CursorHold',
      -- clear_event = 'CursorHoldI',  -- fixed typo here
      message_when_not_committed = '',
    })

    vim.keymap.set('n', '<leader>gb', ':GitBlameToggle<CR>', { desc = "Toggle GitBlame" })
    vim.keymap.set('n', '<leader>go', ':GitBlameOpenFileURL<CR>', { desc = "Open GitBlame File URL" })
    vim.keymap.set('n', '<leader>gy', ':GitBlameCopyFileURL<CR>', { desc = "Copy GitBlame File URL" })
  end,
}
