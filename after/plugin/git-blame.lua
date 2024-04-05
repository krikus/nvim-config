require('gitblame').setup({
  enabled = false,
  -- schedule_event = 'CursorHold',
  -- clear_event = 'CusrosHoldI',
  message_when_not_committed = '',
})
vim.keymap.set('n', '<leader>gb', ':GitBlameToggle<CR>')
vim.keymap.set('n', '<leader>go', ':GitBlameOpenCommitURL<CR>')
vim.keymap.set('n', '<leader>gy', ':GitBlameCopyCommitURL<CR>')
